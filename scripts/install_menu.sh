#!/bin/bash

###
### SIGPI Package Installation Menu
###
### Interactive whiptail menu for selecting and installing packages
###

# Set the packages directory
PACKAGES_DIR="/home/joe/source/SIGpi/packages"
PACKAGES_FILE="$PACKAGES_DIR/PACKAGES"

# SIGpi Configuration
SIGPI_ROOT=$HOME/SIG
SIGPI_ETC=$SIGPI_ROOT/etc
SIGPI_INSTALLED=$SIGPI_ETC/INSTALLED_PKGS

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if whiptail is installed
if ! command -v whiptail &> /dev/null; then
    echo -e "${RED}Error: whiptail is not installed.${NC}"
    echo "Please install it with: sudo apt-get install whiptail"
    exit 1
fi

# Check if packages directory exists
if [ ! -d "$PACKAGES_DIR" ]; then
    echo -e "${RED}Error: Packages directory not found at $PACKAGES_DIR${NC}"
    exit 1
fi

# Create SIGpi directories if they don't exist
if [ ! -d "$SIGPI_ETC" ]; then
    mkdir -p "$SIGPI_ETC"
fi

# Create INSTALLED_PKGS file if it doesn't exist
if [ ! -f "$SIGPI_INSTALLED" ]; then
    touch "$SIGPI_INSTALLED"
fi

# Function to check if a package is installed
is_package_installed() {
    local pkg_name="$1"
    if [ -f "$SIGPI_INSTALLED" ]; then
        grep -q "^$pkg_name," "$SIGPI_INSTALLED" 2>/dev/null
        return $?
    fi
    return 1
}

# Function to read packages and create menu items
build_menu_items() {
    menu_items=()
    local counter=0
    
    # Read the PACKAGES file if it exists
    if [ -f "$PACKAGES_FILE" ]; then
        while IFS=',' read -r name version description date; do
            # Skip empty lines
            [ -z "$name" ] && continue
            
            # Check if the corresponding pkg file exists
            if [ -f "$PACKAGES_DIR/pkg_$name" ]; then
                local status=""
                if is_package_installed "$name"; then
                    status=" [INSTALLED]"
                fi
                menu_items+=("$name" "$description (v$version)$status" "OFF")
                ((counter++))
            fi
        done < "$PACKAGES_FILE"
    else
        # If PACKAGES file doesn't exist, scan directory for pkg_* files
        for pkg_file in "$PACKAGES_DIR"/pkg_*; do
            [ -f "$pkg_file" ] || continue
            
            # Skip the TEMPLATE file
            [ "$(basename "$pkg_file")" = "pkg_TEMPLATE" ] && continue
            
            # Extract package name
            pkg_name=$(basename "$pkg_file" | sed 's/^pkg_//')
            
            # Try to extract description from the package file (look for comment lines)
            description=$(grep -m 1 "^###" "$pkg_file" | tail -n 1 | sed 's/^### //' | sed 's/^##*//')
            [ -z "$description" ] && description="Package: $pkg_name"
            
            local status=""
            if is_package_installed "$pkg_name"; then
                status=" [INSTALLED]"
            fi
            menu_items+=("$pkg_name" "$description$status" "OFF")
            ((counter++))
        done
    fi
    
    if [ $counter -eq 0 ]; then
        echo -e "${RED}Error: No packages found in $PACKAGES_DIR${NC}"
        exit 1
    fi
}

# Function to install a package
install_package() {
    local pkg_name="$1"
    local pkg_script="$PACKAGES_DIR/pkg_$pkg_name"
    
    echo -e "${YELLOW}Installing $pkg_name...${NC}"
    
    if [ ! -f "$pkg_script" ]; then
        echo -e "${RED}Error: Package script not found: $pkg_script${NC}"
        return 1
    fi
    
    # Make sure the script is executable
    chmod +x "$pkg_script"
    
    # Execute the package script with install parameter
    if bash "$pkg_script" install; then
        echo -e "${GREEN}Successfully installed $pkg_name${NC}"
        return 0
    else
        echo -e "${RED}Failed to install $pkg_name${NC}"
        return 1
    fi
}

# Function to remove a package
remove_package() {
    local pkg_name="$1"
    local pkg_script="$PACKAGES_DIR/pkg_$pkg_name"
    
    echo -e "${YELLOW}Removing $pkg_name...${NC}"
    
    if [ ! -f "$pkg_script" ]; then
        echo -e "${RED}Error: Package script not found: $pkg_script${NC}"
        return 1
    fi
    
    # Make sure the script is executable
    chmod +x "$pkg_script"
    
    # Execute the package script with remove parameter
    if bash "$pkg_script" remove; then
        echo -e "${GREEN}Successfully removed $pkg_name${NC}"
        return 0
    else
        echo -e "${RED}Failed to remove $pkg_name${NC}"
        return 1
    fi
}

# Function to purge a package
purge_package() {
    local pkg_name="$1"
    local pkg_script="$PACKAGES_DIR/pkg_$pkg_name"
    
    echo -e "${YELLOW}Purging $pkg_name...${NC}"
    
    if [ ! -f "$pkg_script" ]; then
        echo -e "${RED}Error: Package script not found: $pkg_script${NC}"
        return 1
    fi
    
    # Make sure the script is executable
    chmod +x "$pkg_script"
    
    # Execute the package script with purge parameter
    if bash "$pkg_script" purge; then
        echo -e "${GREEN}Successfully purged $pkg_name${NC}"
        return 0
    else
        echo -e "${RED}Failed to purge $pkg_name${NC}"
        return 1
    fi
}

# Main menu loop
main_menu() {
    while true; do
        # Build menu items array
        menu_items=()
        build_menu_items
        
        # Get terminal dimensions
        term_height=$(tput lines)
        term_width=$(tput cols)
        
        # Set menu dimensions (use 90% of terminal width, max 120)
        menu_width=$((term_width * 9 / 10))
        [ $menu_width -gt 120 ] && menu_width=120
        [ $menu_width -lt 80 ] && menu_width=80
        
        menu_height=$((term_height - 10))
        [ $menu_height -lt 10 ] && menu_height=10
        
        list_height=$((menu_height - 8))
        [ $list_height -lt 5 ] && list_height=5
        
        # Display the checklist menu
        selected=$(whiptail --title "SIGpi Package Management Menu" \
            --checklist "Select packages (use SPACE to select, ENTER to confirm):" \
            $menu_height $menu_width $list_height \
            "${menu_items[@]}" \
            3>&1 1>&2 2>&3)
        
        # Check if user canceled
        exit_status=$?
        if [ $exit_status != 0 ]; then
            echo "Operation canceled."
            exit 0
        fi
        
        # Remove quotes from selected items
        selected=$(echo "$selected" | tr -d '"')
        
        # Check if anything was selected
        if [ -z "$selected" ]; then
            whiptail --title "No Selection" --msgbox "No packages were selected." 8 45
            continue
        fi
        
        # Check if any selected packages are installed
        has_installed=false
        has_uninstalled=false
        for pkg in $selected; do
            if is_package_installed "$pkg"; then
                has_installed=true
            else
                has_uninstalled=true
            fi
        done
        
        # Build action menu based on package status
        action_menu=()
        if [ "$has_uninstalled" = true ]; then
            action_menu+=("install" "Install selected packages")
        fi
        if [ "$has_installed" = true ]; then
            action_menu+=("remove" "Remove selected packages (keep configs)")
            action_menu+=("purge" "Purge selected packages (remove all)")
        fi
        
        # If we have both installed and uninstalled, allow both actions
        if [ "$has_installed" = true ] && [ "$has_uninstalled" = true ]; then
            action=$(whiptail --title "Select Action" \
                --menu "Some packages are installed, some are not. Choose action:" \
                16 70 4 \
                "${action_menu[@]}" \
                3>&1 1>&2 2>&3)
        else
            action=$(whiptail --title "Select Action" \
                --menu "Choose action for selected packages:" \
                15 70 3 \
                "${action_menu[@]}" \
                3>&1 1>&2 2>&3)
        fi
        
        if [ $? != 0 ]; then
            continue
        fi
        
        # Build confirmation message
        confirm_msg="$action the following packages?\n\n"
        for pkg in $selected; do
            if is_package_installed "$pkg"; then
                confirm_msg="${confirm_msg}  - $pkg [INSTALLED]\n"
            else
                confirm_msg="${confirm_msg}  - $pkg\n"
            fi
        done
        
        # Confirm action
        if ! whiptail --title "Confirm Action" \
            --yesno "$confirm_msg" \
            18 70 \
            3>&1 1>&2 2>&3; then
            continue
        fi
        
        # Clear screen and show progress
        clear
        echo -e "${GREEN}======================================${NC}"
        echo -e "${GREEN}  SIGpi Package Management${NC}"
        echo -e "${GREEN}======================================${NC}"
        echo -e "${BLUE}  Action: ${action^^}${NC}"
        echo -e "${GREEN}======================================${NC}"
        echo ""
        
        # Process each selected package
        success_count=0
        fail_count=0
        skipped_count=0
        failed_packages=""
        skipped_packages=""
        
        for pkg in $selected; do
            # Check if action is appropriate for package status
            if [ "$action" = "install" ]; then
                if is_package_installed "$pkg"; then
                    echo -e "${YELLOW}Skipping $pkg (already installed)${NC}"
                    ((skipped_count++))
                    skipped_packages="$skipped_packages\n  - $pkg (already installed)"
                    echo ""
                    continue
                fi
                if install_package "$pkg"; then
                    ((success_count++))
                else
                    ((fail_count++))
                    failed_packages="$failed_packages\n  - $pkg"
                fi
            elif [ "$action" = "remove" ]; then
                if ! is_package_installed "$pkg"; then
                    echo -e "${YELLOW}Skipping $pkg (not installed)${NC}"
                    ((skipped_count++))
                    skipped_packages="$skipped_packages\n  - $pkg (not installed)"
                    echo ""
                    continue
                fi
                if remove_package "$pkg"; then
                    ((success_count++))
                else
                    ((fail_count++))
                    failed_packages="$failed_packages\n  - $pkg"
                fi
            elif [ "$action" = "purge" ]; then
                if ! is_package_installed "$pkg"; then
                    echo -e "${YELLOW}Skipping $pkg (not installed)${NC}"
                    ((skipped_count++))
                    skipped_packages="$skipped_packages\n  - $pkg (not installed)"
                    echo ""
                    continue
                fi
                if purge_package "$pkg"; then
                    ((success_count++))
                else
                    ((fail_count++))
                    failed_packages="$failed_packages\n  - $pkg"
                fi
            fi
            echo ""
        done
        
        # Show summary
        echo -e "${GREEN}======================================${NC}"
        echo -e "${GREEN}  Operation Summary${NC}"
        echo -e "${GREEN}======================================${NC}"
        echo -e "Action performed: ${BLUE}${action^^}${NC}"
        echo -e "Successful: ${GREEN}$success_count${NC}"
        
        if [ $skipped_count -gt 0 ]; then
            echo -e "Skipped: ${YELLOW}$skipped_count${NC}"
            echo -e "${YELLOW}Skipped packages:${NC}"
            echo -e "$skipped_packages"
        fi
        
        if [ $fail_count -gt 0 ]; then
            echo -e "Failed: ${RED}$fail_count${NC}"
            echo -e "${RED}Failed packages:${NC}"
            echo -e "$failed_packages"
        fi
        
        echo ""
        read -p "Press ENTER to return to menu or Ctrl+C to exit..."
    done
}

# Show welcome message
clear
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  SIGpi Package Management Menu${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo "This script will help you install, remove, or purge packages"
echo "from the SIGpi collection."
echo ""
echo "Packages marked with [INSTALLED] are already installed."
echo "You can choose to:"
echo "  - Install new packages"
echo "  - Remove installed packages (keep configuration)"
echo "  - Purge installed packages (remove everything)"
echo ""
read -p "Press ENTER to continue..."

# Run main menu
main_menu
