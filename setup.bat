@echo off
REM Silhouette Card Maker - Windows Setup Script
REM This script sets up the Silhouette Card Maker project on Windows

echo 🎴 Silhouette Card Maker - Windows Setup
echo ======================================
echo.

REM Check if we're in the right directory
if not exist "create_pdf.py" (
    echo [ERROR] This script must be run from the Silhouette Card Maker project directory
    echo [ERROR] Please navigate to the project folder and run this script again
    pause
    exit /b 1
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
echo 1. Place your card images in the appropriate folders:
echo    - Front images: game\front\
echo    - Back images: game\back\
echo    - Double-sided backs: game\double_sided\
echo 2. Run: .venv\Scripts\activate.bat
echo 3. Run: python create_pdf.py
echo.
echo For documentation: hugo server serve -D (then visit http://localhost:1313)
echo.
pause