#!/bin/bash

###
### SIGPI Package Installation Menu
###
### Interactive whiptail menu for selecting and installing packages
###

# Set the packages directory
PACKAGES_DIR="/home/joe/source/SIGpi/packages"
PACKAGES_FILE="$PACKAGES_DIR/PACKAGES"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
                menu_items+=("$name" "$description (v$version)" "OFF")
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
            
            menu_items+=("$pkg_name" "$description" "OFF")
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
        selected=$(whiptail --title "SIGpi Package Installation Menu" \
            --checklist "Select packages to install (use SPACE to select, ENTER to confirm):" \
            $menu_height $menu_width $list_height \
            "${menu_items[@]}" \
            3>&1 1>&2 2>&3)
        
        # Check if user canceled
        exit_status=$?
        if [ $exit_status != 0 ]; then
            echo "Installation canceled."
            exit 0
        fi
        
        # Remove quotes from selected items
        selected=$(echo "$selected" | tr -d '"')
        
        # Check if anything was selected
        if [ -z "$selected" ]; then
            whiptail --title "No Selection" --msgbox "No packages were selected." 8 45
            continue
        fi
        
        # Confirm installation
        confirm=$(whiptail --title "Confirm Installation" \
            --yesno "Install the following packages?\n\n$selected" \
            12 60 \
            3>&1 1>&2 2>&3)
        
        if [ $? != 0 ]; then
            continue
        fi
        
        # Clear screen and show installation progress
        clear
        echo -e "${GREEN}======================================${NC}"
        echo -e "${GREEN}  SIGpi Package Installation${NC}"
        echo -e "${GREEN}======================================${NC}"
        echo ""
        
        # Install each selected package
        success_count=0
        fail_count=0
        failed_packages=""
        
        for pkg in $selected; do
            if install_package "$pkg"; then
                ((success_count++))
            else
                ((fail_count++))
                failed_packages="$failed_packages\n  - $pkg"
            fi
            echo ""
        done
        
        # Show summary
        echo -e "${GREEN}======================================${NC}"
        echo -e "${GREEN}  Installation Summary${NC}"
        echo -e "${GREEN}======================================${NC}"
        echo -e "Successfully installed: ${GREEN}$success_count${NC}"
        echo -e "Failed: ${RED}$fail_count${NC}"
        
        if [ $fail_count -gt 0 ]; then
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
echo -e "${GREEN}  SIGpi Package Installation Menu${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo "This script will help you install packages from the SIGpi collection."
echo ""
read -p "Press ENTER to continue..."

# Run main menu
main_menu
