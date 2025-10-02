#!/bin/bash

# Silhouette Card Maker - Easy Setup Script
# This script sets up everything needed to run the Silhouette Card Maker project

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
    
    print_status "Installing mise..."
    
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
    
    print_status "Installing direnv..."
    
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
    
    print_status "Setting up shell integration for $SHELL..."
    
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

# Function to create project directories
create_directories() {
    print_status "Creating project directories..."
    
    mkdir -p game/front
    mkdir -p game/back
    mkdir -p game/double_sided
    mkdir -p game/output
    mkdir -p game/decklist
    
    print_success "Project directories created"
}

# Function to setup the project
setup_project() {
    print_status "Setting up Silhouette Card Maker project..."
    
    # Install tools
    install_mise
    install_direnv
    
    # Setup shell integration
    setup_shell_integration
    
    # Create directories
    create_directories
    
    # Make .envrc executable
    chmod +x .envrc
    
    print_success "Project setup complete!"
    print_status ""
    print_status "Next steps:"
    print_status "1. Restart your terminal or run: source ~/.zshrc (or ~/.bashrc)"
    print_status "2. Navigate to this directory: cd $(pwd)"
    print_status "3. Allow direnv: direnv allow"
    print_status "4. Place your card images in the appropriate folders:"
    print_status "   - Front images: game/front/"
    print_status "   - Back images: game/back/"
    print_status "   - Double-sided backs: game/double_sided/"
    print_status "5. Run: python create_pdf.py"
    print_status ""
    print_status "For documentation: hugo server serve -D (then visit http://localhost:1313)"
}

# Main execution
main() {
    echo "🎴 Silhouette Card Maker - Easy Setup"
    echo "======================================"
    echo ""
    
    # Check if we're in the right directory
    if [ ! -f "create_pdf.py" ]; then
        print_error "This script must be run from the Silhouette Card Maker project directory"
        print_error "Please navigate to the project folder and run this script again"
        exit 1
    fi
    
    # Check for required files
    if [ ! -f "requirements.txt" ]; then
        print_error "requirements.txt not found. Are you in the correct directory?"
        exit 1
    fi
    
    setup_project
}

# Run main function
main "$@"