#!/usr/bin/env python3
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GObject, GLib

import csv
import subprocess
import os
from pathlib import Path

PACKAGE_FILE = "PACKAGES"


class Package:
    def __init__(self, name, version, description, expiry):
        self.name = name
        self.version = version
        self.description = description
        self.expiry = expiry
        self.installed = False


def check_installed(pkg_name: str) -> bool:
    """
    Check if a package is installed using dpkg -s.
    """
    try:
        subprocess.run(
            ["dpkg", "-s", pkg_name],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return True
    except subprocess.CalledProcessError:
        return False


def run_command_async(command, callback):
    """
    Run a command asynchronously and call callback(success, output).
    """
    def _worker():
        try:
            proc = subprocess.run(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                check=False,
            )
            success = proc.returncode == 0
            output = proc.stdout
        except Exception as e:
            success = False
            output = str(e)

        GLib.idle_add(callback, success, output)
        return False

    GLib.idle_add(_worker)


class ModuleManagerWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="SIGpi Package Manager")
        self.set_default_size(1000, 500)

        self.packages = self.load_packages(PACKAGE_FILE)

        # Main layout
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(vbox)

        # Toolbar
        toolbar = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        vbox.pack_start(toolbar, False, False, 0)

        refresh_button = Gtk.Button(label="Refresh Status")
        refresh_button.connect("clicked", self.on_refresh_clicked)
        toolbar.pack_start(refresh_button, False, False, 0)

        self.status_label = Gtk.Label(label="Ready")
        toolbar.pack_end(self.status_label, False, False, 0)

        # TreeView model: name, version, description, expiry, installed
        self.store = Gtk.ListStore(str, str, str, str, str)
        self.populate_store()

        # TreeView
        treeview = Gtk.TreeView(model=self.store)
        self.treeview = treeview

        renderer_text = Gtk.CellRendererText()

        columns = [
            ("Name", 0),
            ("Version", 1),
            ("Description", 2),
            ("Expiry", 3),
            ("Status", 4),
        ]

        for title, col_id in columns:
            column = Gtk.TreeViewColumn(title, renderer_text, text=col_id)
            column.set_resizable(True)
            column.set_expand(col_id == 2)  # Description expands
            treeview.append_column(column)

        # Selection
        self.selection = treeview.get_selection()
        self.selection.set_mode(Gtk.SelectionMode.SINGLE)

        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scrolled.add(treeview)
        vbox.pack_start(scrolled, True, True, 0)

        # Action buttons
        action_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        vbox.pack_start(action_box, False, False, 6)

        self.install_button = Gtk.Button(label="Install")
        self.install_button.connect("clicked", self.on_install_clicked)
        action_box.pack_start(self.install_button, False, False, 0)

        self.remove_button = Gtk.Button(label="Remove")
        self.remove_button.connect("clicked", self.on_remove_clicked)
        action_box.pack_start(self.remove_button, False, False, 0)

        self.purge_button = Gtk.Button(label="Purge")
        self.purge_button.connect("clicked", self.on_purge_clicked)
        action_box.pack_start(self.purge_button, False, False, 0)

        quit_button = Gtk.Button(label="Quit")
        quit_button.connect("clicked", lambda *_: Gtk.main_quit())
        action_box.pack_end(quit_button, False, False, 0)

        # Update button sensitivity when selection changes
        self.selection.connect("changed", self.on_selection_changed)
        self.on_selection_changed(self.selection)

        self.connect("destroy", Gtk.main_quit)

    def load_packages(self, filename):
        packages = []
        path = Path(filename)
        if not path.exists():
            print(f"PACKAGE file not found: {filename}")
            return packages

        with path.open() as f:
            reader = csv.reader(f)
            for row in reader:
                if not row or len(row) < 4:
                    continue
                name = row[0].strip()
                version = row[1].strip()
                description = row[2].strip()
                expiry = row[3].strip()
                pkg = Package(name, version, description, expiry)
                pkg.installed = check_installed(name)
                packages.append(pkg)
        return packages

    def populate_store(self):
        self.store.clear()
        for pkg in self.packages:
            status = "Installed" if pkg.installed else "Not installed"
            self.store.append([
                pkg.name,
                pkg.version,
                pkg.description,
                pkg.expiry,
                status,
            ])

    def get_selected_package(self):
        model, treeiter = self.selection.get_selected()
        if treeiter is None:
            return None, None
        name = model[treeiter][0]
        for pkg in self.packages:
            if pkg.name == name:
                return pkg, treeiter
        return None, None

    def on_selection_changed(self, selection):
        pkg, _ = self.get_selected_package()
        if pkg is None:
            self.install_button.set_sensitive(False)
            self.remove_button.set_sensitive(False)
            self.purge_button.set_sensitive(False)
            return

        self.install_button.set_sensitive(not pkg.installed)
        self.remove_button.set_sensitive(pkg.installed)
        self.purge_button.set_sensitive(pkg.installed)

    def set_status(self, text):
        self.status_label.set_text(text)

    def on_refresh_clicked(self, button):
        self.set_status("Refreshing package status...")
        for pkg in self.packages:
            pkg.installed = check_installed(pkg.name)
        self.populate_store()
        self.set_status("Status refreshed")

    def on_install_clicked(self, button):
        pkg, treeiter = self.get_selected_package()
        if pkg is None:
            return

        # Change this command if you want a safer mock:
        # command = ["echo", f"Installing {pkg.name}"]
        #command = ["sudo", "apt-get", "install", "-y", pkg.name]
        command = ["SIGpi", "install", pkg.name]

        self.set_status(f"Installing {pkg.name}...")
        self.install_button.set_sensitive(False)
        self.remove_button.set_sensitive(False)
        self.purge_button.set_sensitive(False)

        def done(success, output):
            if success:
                pkg.installed = True
                self.store[treeiter][4] = "Installed"
                self.set_status(f"Installed {pkg.name}")
            else:
                self.set_status(f"Failed to install {pkg.name}")
                print(output)
            self.on_selection_changed(self.selection)

        run_command_async(command, done)

    def on_remove_clicked(self, button):
        pkg, treeiter = self.get_selected_package()
        if pkg is None:
            return

        # Change this command if you want a safer mock:
        # command = ["echo", f"Removing {pkg.name}"]
        #command = ["sudo", "apt-get", "remove", "-y", pkg.name]
        command = ["SIGpi", "remove", "-y", pkg.name]

        self.set_status(f"Removing {pkg.name}...")
        self.install_button.set_sensitive(False)
        self.remove_button.set_sensitive(False)
        self.purge_button.set_sensitive(False)

        def done(success, output):
            if success:
                pkg.installed = False
                self.store[treeiter][4] = "Not installed"
                self.set_status(f"Removed {pkg.name}")
            else:
                self.set_status(f"Failed to remove {pkg.name}")
                print(output)
            self.on_selection_changed(self.selection)

        run_command_async(command, done)

    def on_purge_clicked(self, button):
        pkg, treeiter = self.get_selected_package()
        if pkg is None:
            return

        # Change this command if you want a safer mock:
        # command = ["echo", f"Purging {pkg.name}"]
        command = ["SIGpi", "purge", "-y", pkg.name]

        self.set_status(f"Purging {pkg.name}...")
        self.install_button.set_sensitive(False)
        self.remove_button.set_sensitive(False)
        self.purge_button.set_sensitive(False)

        def done(success, output):
            if success:
                pkg.installed = False
                self.store[treeiter][4] = "Not installed"
                self.set_status(f"Purged {pkg.name}")
            else:
                self.set_status(f"Failed to purge {pkg.name}")
                print(output)
            self.on_selection_changed(self.selection)

        run_command_async(command, done)


def main():
    win = ModuleManagerWindow()
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
