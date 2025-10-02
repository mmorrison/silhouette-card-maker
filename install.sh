#!/bin/bash

# Silhouette Card Maker - One-Liner Installer
# This script downloads, sets up, and configures everything automatically
# Usage: curl -sSL https://raw.githubusercontent.com/Alan-Cha/silhouette-card-maker/main/install.sh | bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
}

print_step() {
    echo -e "${CYAN}▶ $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to install mise
install_mise() {
    local os=$(detect_os)
    
    if command_exists mise; then
        print_success "mise is already installed"
        return 0
    fi
    
    print_step "Installing mise..."
    
    case $os in
        "macos")
            if command_exists brew; then
                brew install mise
            else
                # Install via curl
                curl https://mise.run | sh
                # Add to PATH for current session
                export PATH="$HOME/.local/bin:$PATH"
            fi
            ;;
        "linux")
            curl https://mise.run | sh
            # Add to PATH for current session
            export PATH="$HOME/.local/bin:$PATH"
            ;;
        "windows")
            print_error "Windows installation not supported in this script. Please install mise manually from https://mise.run"
            exit 1
            ;;
        *)
            print_error "Unsupported operating system: $os"
            exit 1
            ;;
    esac
    
    print_success "mise installed successfully"
}

# Function to install direnv
install_direnv() {
    local os=$(detect_os)
    
    if command_exists direnv; then
        print_success "direnv is already installed"
        return 0
    fi
    
    print_step "Installing direnv..."
    
    case $os in
        "macos")
            if command_exists brew; then
                brew install direnv
            else
                print_warning "Homebrew not found. Please install direnv manually: https://direnv.net/docs/installation.html"
                return 1
            fi
            ;;
        "linux")
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y direnv
            elif command_exists yum; then
                sudo yum install -y direnv
            elif command_exists dnf; then
                sudo dnf install -y direnv
            elif command_exists pacman; then
                sudo pacman -S direnv
            else
                print_warning "Package manager not found. Please install direnv manually: https://direnv.net/docs/installation.html"
                return 1
            fi
            ;;
        "windows")
            print_warning "Windows direnv installation not supported in this script. Please install manually: https://direnv.net/docs/installation.html"
            return 1
            ;;
    esac
    
    print_success "direnv installed successfully"
}

# Function to setup shell integration
setup_shell_integration() {
    local shell_config=""
    
    # Detect shell
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_config="$HOME/.bashrc"
    else
        print_warning "Unknown shell: $SHELL. Please add mise and direnv to your shell configuration manually."
        return 1
    fi
    
    print_step "Setting up shell integration for $SHELL..."
    
    # Add mise to shell config
    if ! grep -q "mise" "$shell_config" 2>/dev/null; then
        echo 'eval "$(mise activate zsh)"' >> "$shell_config"
        print_success "Added mise to $shell_config"
    else
        print_success "mise already configured in $shell_config"
    fi
    
    # Add direnv to shell config
    if ! grep -q "direnv" "$shell_config" 2>/dev/null; then
        echo 'eval "$(direnv hook zsh)"' >> "$shell_config"
        print_success "Added direnv to $shell_config"
    else
        print_success "direnv already configured in $shell_config"
    fi
    
    print_warning "Please restart your terminal or run 'source $shell_config' to activate the changes"
}

# Function to download and setup the project
download_and_setup() {
    local install_dir="$HOME/silhouette-card-maker"
    
    print_step "Downloading Silhouette Card Maker..."
    
    # Remove existing directory if it exists
    if [ -d "$install_dir" ]; then
        print_warning "Directory $install_dir already exists. Removing it..."
        rm -rf "$install_dir"
    fi
    
    # Clone the repository
    git clone https://github.com/Alan-Cha/silhouette-card-maker.git "$install_dir"
    
    print_success "Project downloaded to $install_dir"
    
    # Change to the project directory
    cd "$install_dir"
    
    # Make scripts executable (if they exist)
    [ -f "setup.sh" ] && chmod +x setup.sh
    [ -f ".envrc" ] && chmod +x .envrc
    
    # Create project directories
    print_step "Creating project directories..."
    mkdir -p game/front
    mkdir -p game/back
    mkdir -p game/double_sided
    mkdir -p game/output
    mkdir -p game/decklist
    
    print_success "Project directories created"
    
    # Trust mise configuration
    print_step "Configuring mise..."
    mise trust
    
    print_success "mise configuration trusted"
}

# Function to show final instructions
show_final_instructions() {
    local install_dir="$HOME/silhouette-card-maker"
    
    print_header ""
    print_header "🎴 Silhouette Card Maker Installation Complete!"
    print_header "=============================================="
    print_header ""
    
    print_status "Project installed to: $install_dir"
    print_status ""
    print_status "Next steps:"
    print_status "1. Restart your terminal or run: source ~/.zshrc (or ~/.bashrc)"
    print_status "2. Navigate to the project: cd $install_dir"
    print_status "3. Allow direnv: direnv allow"
    print_status ""
    print_status "Quick start examples:"
    print_status "• Riftbound cards: mise run riftbound-workflow"
    print_status "• Lorcana cards: mise run lorcana-workflow"
    print_status "• Magic: The Gathering: mise run mtg-workflow"
    print_status "• See all tasks: mise run help"
    print_status ""
    print_status "Documentation: mise run docs (then visit http://localhost:1313)"
    print_status ""
    print_success "Happy card making! 🎉"
}

# Main execution
main() {
    print_header "🎴 Silhouette Card Maker - One-Liner Installer"
    print_header "=============================================="
    print_header ""
    
    # Check for required tools
    if ! command_exists git; then
        print_error "Git is required but not installed. Please install Git first."
        exit 1
    fi
    
    if ! command_exists curl; then
        print_error "curl is required but not installed. Please install curl first."
        exit 1
    fi
    
    # Install tools
    install_mise
    install_direnv
    
    # Setup shell integration
    setup_shell_integration
    
    # Download and setup project
    download_and_setup
    
    # Show final instructions
    show_final_instructions
}

# Run main function
main "$@"