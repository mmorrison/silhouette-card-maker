@echo off
REM Silhouette Card Maker - Windows Setup Script
REM This script sets up the Silhouette Card Maker project on Windows
REM Usage: Download this file and run it, or use PowerShell to download and run

echo 🎴 Silhouette Card Maker - Windows Setup
echo ======================================
echo.

REM Check if Git is available
git --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Git is not installed. Will download ZIP file instead.
    set USE_ZIP=1
) else (
    echo [SUCCESS] Git is available
    set USE_ZIP=0
)

REM Check if Scoop is available
scoop --version >nul 2>&1
if errorlevel 1 (
    echo [INFO] Scoop not found. Installing Scoop...
    powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
    if errorlevel 1 (
        echo [ERROR] Failed to install Scoop
        echo [INFO] Please install Scoop manually from https://scoop.sh
        pause
        exit /b 1
    )
    echo [SUCCESS] Scoop installed successfully
) else (
    echo [SUCCESS] Scoop is already installed
)

REM Install mise using Scoop
echo [INFO] Installing mise using Scoop...
scoop install mise
if errorlevel 1 (
    echo [ERROR] Failed to install mise
    pause
    exit /b 1
)
echo [SUCCESS] mise installed successfully

REM Install direnv using Scoop
echo [INFO] Installing direnv using Scoop...
scoop install direnv
if errorlevel 1 (
    echo [WARNING] Failed to install direnv. Continuing without it...
) else (
    echo [SUCCESS] direnv installed successfully
)

REM Check if we're in the right directory
if not exist "create_pdf.py" (
    echo [INFO] Setting up Silhouette Card Maker project...
    echo [INFO] Downloading project to: %USERPROFILE%\silhouette-card-maker
    
    REM Remove existing directory if it exists
    if exist "%USERPROFILE%\silhouette-card-maker" (
        echo [WARNING] Directory %USERPROFILE%\silhouette-card-maker already exists. Removing it...
        rmdir /s /q "%USERPROFILE%\silhouette-card-maker"
    )
    
    if "%USE_ZIP%"=="1" (
        echo [INFO] Downloading project as ZIP file...
        powershell -Command "Invoke-WebRequest -Uri 'https://github.com/mmorrison/silhouette-card-maker/archive/refs/heads/main.zip' -OutFile '%USERPROFILE%\silhouette-card-maker.zip'"
        if errorlevel 1 (
            echo [WARNING] Enhanced version ZIP failed, trying original repository...
            powershell -Command "Invoke-WebRequest -Uri 'https://github.com/Alan-Cha/silhouette-card-maker/archive/refs/heads/main.zip' -OutFile '%USERPROFILE%\silhouette-card-maker.zip'"
        )
        if errorlevel 1 (
            echo [ERROR] Failed to download project ZIP
            pause
            exit /b 1
        )
        
        echo [INFO] Extracting ZIP file...
        powershell -Command "Expand-Archive -Path '%USERPROFILE%\silhouette-card-maker.zip' -DestinationPath '%USERPROFILE%' -Force"
        if errorlevel 1 (
            echo [ERROR] Failed to extract ZIP file
            pause
            exit /b 1
        )
        
        REM Rename the extracted folder
        if exist "%USERPROFILE%\silhouette-card-maker-main" (
            move "%USERPROFILE%\silhouette-card-maker-main" "%USERPROFILE%\silhouette-card-maker"
        )
        
        REM Clean up ZIP file
        del "%USERPROFILE%\silhouette-card-maker.zip"
        
        echo [SUCCESS] Project downloaded and extracted successfully
    ) else (
        REM Clone the repository (try enhanced version first, fallback to original)
        echo [INFO] Attempting to clone enhanced version...
        git clone https://github.com/mmorrison/silhouette-card-maker.git "%USERPROFILE%\silhouette-card-maker"
        if errorlevel 1 (
            echo [WARNING] Enhanced version not found, trying original repository...
            git clone https://github.com/Alan-Cha/silhouette-card-maker.git "%USERPROFILE%\silhouette-card-maker"
        )
        if errorlevel 1 (
            echo [ERROR] Failed to download project
            pause
            exit /b 1
        )
        
        echo [SUCCESS] Project downloaded successfully
    )
    
    cd "%USERPROFILE%\silhouette-card-maker"
)

REM Check for required files
if not exist "requirements.txt" (
    echo [ERROR] requirements.txt not found. Are you in the correct directory?
    pause
    exit /b 1
)

echo [INFO] Setting up Silhouette Card Maker project...

REM Create directories
echo [INFO] Creating project directories...
if not exist "game\front" mkdir "game\front"
if not exist "game\back" mkdir "game\back"
if not exist "game\double_sided" mkdir "game\double_sided"
if not exist "game\output" mkdir "game\output"
if not exist "game\decklist" mkdir "game\decklist"

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH
    echo [INFO] Please install Python from https://python.org
    echo [INFO] Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

REM Create virtual environment
echo [INFO] Creating Python virtual environment...
if not exist ".venv" (
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment
        pause
        exit /b 1
    )
)

REM Activate virtual environment and install dependencies
echo [INFO] Installing Python dependencies...
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

REM Trust mise configuration
echo [INFO] Trusting mise configuration...
mise trust
if errorlevel 1 (
    echo [WARNING] Failed to trust mise configuration
) else (
    echo [SUCCESS] mise configuration trusted
)

REM Allow direnv
echo [INFO] Allowing direnv...
direnv allow
if errorlevel 1 (
    echo [WARNING] Failed to allow direnv
) else (
    echo [SUCCESS] direnv allowed
)

REM Initialize Hugo submodule if hugo directory exists
if exist "hugo" (
    if not exist "hugo\themes\hextra\.git" (
        echo [INFO] Initializing Hugo submodule...
        git submodule update --init --recursive
    )
)

echo.
echo [SUCCESS] Project setup complete!
echo.
echo Next steps:
echo 1. Restart PowerShell or Command Prompt
echo 2. Navigate to the project: cd %USERPROFILE%\silhouette-card-maker
echo 3. Place your card images in the appropriate folders:
echo    - Front images: game\front\
echo    - Back images: game\back\
echo    - Double-sided backs: game\double_sided\
echo.
echo Quick start examples:
echo • Riftbound cards: mise run riftbound-workflow
echo • Lorcana cards: mise run lorcana-workflow
echo • Magic: The Gathering: mise run mtg-workflow
echo • See all tasks: mise run help
echo.
echo For documentation: mise run docs (then visit http://localhost:1313)
echo.
pause