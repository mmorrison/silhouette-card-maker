# Silhouette Card Maker - PowerShell Installer
# This script downloads, sets up, and configures everything automatically
# Usage: Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alan-Cha/silhouette-card-maker/main/install.ps1").Content

# Set error action preference
$ErrorActionPreference = "Stop"

# Colors for output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Status {
    param([string]$Message)
    Write-ColorOutput "[INFO] $Message" "Cyan"
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "[SUCCESS] $Message" "Green"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "[WARNING] $Message" "Yellow"
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "[ERROR] $Message" "Red"
}

# Main installation function
function Install-SilhouetteCardMaker {
    Write-ColorOutput "🎴 Silhouette Card Maker - PowerShell Installer" "Magenta"
    Write-ColorOutput "===============================================" "Magenta"
    Write-Host ""
    
# Check if Git is available
try {
    $gitVersion = git --version
    Write-Success "Git is available: $gitVersion"
    $useZip = $false
}
catch {
    Write-Warning "Git is not installed. Will download ZIP file instead."
    $useZip = $true
}

# Check if Scoop is available
try {
    $scoopVersion = scoop --version
    Write-Success "Scoop is available: $scoopVersion"
}
catch {
    Write-Status "Scoop not found. Installing Scoop..."
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        Write-Success "Scoop installed successfully"
    }
    catch {
        Write-Error "Failed to install Scoop"
        Write-Status "Please install Scoop manually from https://scoop.sh"
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Install mise using Scoop
Write-Status "Installing mise using Scoop..."
try {
    scoop install mise
    Write-Success "mise installed successfully"
}
catch {
    Write-Error "Failed to install mise"
    Read-Host "Press Enter to exit"
    exit 1
}

# Install direnv using Scoop
Write-Status "Installing direnv using Scoop..."
try {
    scoop install direnv
    Write-Success "direnv installed successfully"
}
catch {
    Write-Warning "Failed to install direnv. Continuing without it..."
}
    
    # Check if Python is available
    try {
        $pythonVersion = python --version
        Write-Success "Python is available: $pythonVersion"
    }
    catch {
        Write-Error "Python is not installed or not in PATH"
        Write-Status "Please install Python from https://python.org"
        Write-Status "Make sure to check 'Add Python to PATH' during installation"
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    # Set installation directory
    $installDir = "$env:USERPROFILE\silhouette-card-maker"
    
    # Remove existing directory if it exists
    if (Test-Path $installDir) {
        Write-Warning "Directory $installDir already exists. Removing it..."
        Remove-Item -Path $installDir -Recurse -Force
    }
    
    # Download the repository (Git or ZIP)
    Write-Status "Downloading Silhouette Card Maker..."
    
    if ($useZip) {
        Write-Status "Downloading project as ZIP file..."
        try {
            $zipPath = "$env:USERPROFILE\silhouette-card-maker.zip"
            Invoke-WebRequest -Uri "https://github.com/mmorrison/silhouette-card-maker/archive/refs/heads/main.zip" -OutFile $zipPath
            Write-Success "ZIP file downloaded"
        }
        catch {
            Write-Warning "Enhanced version ZIP failed, trying original repository..."
            try {
                Invoke-WebRequest -Uri "https://github.com/Alan-Cha/silhouette-card-maker/archive/refs/heads/main.zip" -OutFile $zipPath
                Write-Success "ZIP file downloaded"
            }
            catch {
                Write-Error "Failed to download project ZIP from both repositories"
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        
        Write-Status "Extracting ZIP file..."
        try {
            Expand-Archive -Path $zipPath -DestinationPath $env:USERPROFILE -Force
            Remove-Item $zipPath
            
            # Rename the extracted folder
            $extractedDir = "$env:USERPROFILE\silhouette-card-maker-main"
            if (Test-Path $extractedDir) {
                Move-Item $extractedDir $installDir
            }
            
            Write-Success "Project downloaded and extracted to $installDir"
        }
        catch {
            Write-Error "Failed to extract ZIP file"
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
    else {
        Write-Status "Attempting to clone enhanced version..."
        try {
            git clone https://github.com/mmorrison/silhouette-card-maker.git $installDir
            Write-Success "Project downloaded to $installDir"
        }
        catch {
            Write-Warning "Enhanced version not found, trying original repository..."
            try {
                git clone https://github.com/Alan-Cha/silhouette-card-maker.git $installDir
                Write-Success "Project downloaded to $installDir"
            }
            catch {
                Write-Error "Failed to download project from both repositories"
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
    }
    
    # Change to project directory
    Set-Location $installDir
    
    # Create project directories
    Write-Status "Creating project directories..."
    $directories = @("game\front", "game\back", "game\double_sided", "game\output", "game\decklist")
    foreach ($dir in $directories) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    Write-Success "Project directories created"
    
    # Create virtual environment
    Write-Status "Creating Python virtual environment..."
    if (!(Test-Path ".venv")) {
        python -m venv .venv
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to create virtual environment"
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
    Write-Success "Virtual environment created"
    
    # Activate virtual environment and install dependencies
    Write-Status "Installing Python dependencies..."
    $activateScript = ".venv\Scripts\Activate.ps1"
    if (Test-Path $activateScript) {
        & $activateScript
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to install dependencies"
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
    else {
        Write-Error "Virtual environment activation script not found"
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Success "Dependencies installed"
    
    # Setup shell integration for mise and direnv
    Write-Status "Setting up shell integration..."
    $profilePath = $PROFILE
    $profileDir = Split-Path $profilePath -Parent
    
    # Create profile directory if it doesn't exist
    if (!(Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    # Add mise to PowerShell profile
    $miseConfig = 'eval "$(mise activate pwsh)"'
    if (!(Get-Content $profilePath -ErrorAction SilentlyContinue | Select-String "mise")) {
        Add-Content -Path $profilePath -Value $miseConfig
        Write-Success "Added mise to PowerShell profile"
    }
    else {
        Write-Success "mise already configured in PowerShell profile"
    }
    
    # Add direnv to PowerShell profile
    $direnvConfig = 'Invoke-Expression "$(direnv hook pwsh)"'
    if (!(Get-Content $profilePath -ErrorAction SilentlyContinue | Select-String "direnv")) {
        Add-Content -Path $profilePath -Value $direnvConfig
        Write-Success "Added direnv to PowerShell profile"
    }
    else {
        Write-Success "direnv already configured in PowerShell profile"
    }
    
    # Trust mise configuration
    Write-Status "Trusting mise configuration..."
    mise trust
    Write-Success "mise configuration trusted"
    
    # Allow direnv
    Write-Status "Allowing direnv..."
    direnv allow
    Write-Success "direnv allowed"
    
    # Initialize Hugo submodule if hugo directory exists
    if (Test-Path "hugo") {
        if (!(Test-Path "hugo\themes\hextra\.git")) {
            Write-Status "Initializing Hugo submodule..."
            git submodule update --init --recursive
        }
    }
    
    # Show final instructions
    Write-Host ""
    Write-ColorOutput "🎴 Silhouette Card Maker Installation Complete!" "Magenta"
    Write-ColorOutput "==============================================" "Magenta"
    Write-Host ""
    Write-Status "Project installed to: $installDir"
    Write-Host ""
    Write-Status "Next steps:"
    Write-Status "1. Restart PowerShell or run: . `$PROFILE"
    Write-Status "2. Navigate to the project: cd '$installDir'"
    Write-Status "3. Place your card images in the appropriate folders:"
    Write-Status "   - Front images: game\front\"
    Write-Status "   - Back images: game\back\"
    Write-Status "   - Double-sided backs: game\double_sided\"
    Write-Host ""
    Write-Status "Quick start examples:"
    Write-Status "• Riftbound cards: mise run riftbound-workflow"
    Write-Status "• Lorcana cards: mise run lorcana-workflow"
    Write-Status "• Magic: The Gathering: mise run mtg-workflow"
    Write-Status "• See all tasks: mise run help"
    Write-Host ""
    Write-Status "For documentation: mise run docs (then visit http://localhost:1313)"
    Write-Host ""
    Write-Success "Happy card making! 🎉"
    Write-Host ""
    Read-Host "Press Enter to exit"
}

# Run the installation
Install-SilhouetteCardMaker