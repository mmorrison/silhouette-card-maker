# 🎴 Silhouette Card Maker - Easy Setup Guide

This guide will help you set up the Silhouette Card Maker project quickly and easily, even if you're not a developer!

## 🚀 Super Quick Start (One Command!)

**Just copy and paste this single command:**

```bash
curl -sSL https://raw.githubusercontent.com/mmorrison/silhouette-card-maker/main/install.sh | bash
```

That's it! This **install script** will:
- ✅ Download the project automatically
- ✅ Install mise and direnv
- ✅ Set up your shell configuration
- ✅ Create all necessary directories
- ✅ Configure the environment

## 🚀 Manual Setup (Alternative)

If you prefer to download the project manually first, then use the **setup script**:

### Step 1: Download the Project
```bash
# Download the project
git clone https://github.com/Alan-Cha/silhouette-card-maker.git
cd silhouette-card-maker
```

### Step 2: Run the Setup Script
```bash
# Make the setup script executable and run it
chmod +x setup.sh
./setup.sh
```

### Step 3: Follow the Instructions
The **setup script** will guide you through:
- Installing mise (tool manager)
- Installing direnv (environment manager)
- Setting up your shell configuration
- Creating necessary directories

**Note**: The setup script assumes you already have the project downloaded. It does NOT download the project for you.

## 📋 Install vs Setup Scripts

| Feature | Install Script | Setup Script |
|---------|---------------|--------------|
| **Downloads Project** | ✅ Yes | ❌ No |
| **Installs Tools** | ✅ Yes | ✅ Yes |
| **Shell Integration** | ✅ Yes | ✅ Yes |
| **Creates Directories** | ✅ Yes | ✅ Yes |
| **One Command** | ✅ Yes | ❌ No (need to clone first) |
| **Best For** | New users | Developers/manual control |

### When to Use Which:
- **Use Install Script**: First time setup, want everything automated
- **Use Setup Script**: Already cloned the repo, want manual control

### Step 4: Restart Your Terminal
After the setup completes, restart your terminal or run:
```bash
source ~/.zshrc  # or ~/.bashrc if you use bash
```

### Step 5: Activate the Environment
```bash
# Navigate to the project directory
cd silhouette-card-maker

# Allow direnv to manage the environment
direnv allow
```

That's it! The environment will automatically activate whenever you enter this directory.

## 📁 Using the Project

### Adding Your Card Images
1. **Front images**: Place them in `game/front/`
2. **Back images**: Place them in `game/back/`
3. **Double-sided backs**: Place them in `game/double_sided/`

### Creating Your PDF

#### Using mise tasks (Recommended)
```bash
# Basic PDF creation
mise run create-pdf

# Poker-sized cards on A4 paper
mise run create-pdf-poker

# Japanese-sized cards (Yu-Gi-Oh!)
mise run create-pdf-japanese

# High quality output
mise run create-pdf-high-quality

# With saved offset calibration
mise run create-pdf-with-offset
```

#### Manual commands
```bash
# Basic usage
python create_pdf.py

# With custom options
python create_pdf.py --card_size poker --paper_size a4
```

Your PDF will be created at `game/output/game.pdf`

### Using Game Plugins (Automatic Card Fetching)

The project includes plugins that automatically fetch card images from various sources. This is much easier than manually downloading images!

#### Riftbound Cards
```bash
# 1. Place your decklist in game/decklist/deck.txt
# 2. Choose your format and run:

# Tabletop Simulator format
mise run riftbound-fetch-tts

# Pixelborn format  
mise run riftbound-fetch-pixelborn

# Piltover Archive format
mise run riftbound-fetch-piltover

# Piltover Archive format (using Riftmana source)
mise run riftbound-fetch-piltover-riftmana

# 3. Create your PDF
mise run create-pdf
```

#### Lorcana Cards
```bash
# 1. Place your Dreamborn decklist in game/decklist/deck.txt
# 2. Fetch the cards
mise run lorcana-fetch

# 3. Create your PDF
mise run create-pdf
```

#### Magic: The Gathering Cards
```bash
# 1. Place your decklist in game/decklist/deck.txt
# 2. Choose your format:

# MTG Arena format
mise run mtg-fetch-mtga

# Moxfield format
mise run mtg-fetch-moxfield

# Scryfall format
mise run mtg-fetch-scryfall

# 3. Create your PDF
mise run create-pdf
```

#### Other Supported Games
- **Yu-Gi-Oh!**: `mise run yugioh-fetch-ydk` or `mise run yugioh-fetch-ydke`
- **Digimon**: `mise run digimon-fetch-tts` or `mise run digimon-fetch-digimoncard`
- **One Piece**: `mise run onepiece-fetch-optsg` or `mise run onepiece-fetch-egman`
- **Flesh and Blood**: `mise run fab-fetch-fabrary`
- **Grand Archive**: `mise run ga-fetch-omnideck`
- **Gundam**: `mise run gundam-fetch-deckplanet` or `mise run gundam-fetch-limitless`
- **Altered**: `mise run altered-fetch-ajordat`
- **Netrunner**: `mise run netrunner-fetch-text` or `mise run netrunner-fetch-jinteki`

### Quick Workflows
```bash
# Get step-by-step instructions for popular games
mise run riftbound-workflow
mise run lorcana-workflow
mise run mtg-workflow
```

### Viewing Documentation
```bash
# Start the documentation server
mise run docs

# Then visit http://localhost:1313 in your browser
```

## 🎯 Available Tasks

You can see all available tasks with:
```bash
mise run help
```

### Core Tasks
- `create-pdf` - Create basic PDF
- `create-pdf-poker` - Create poker-sized cards on A4
- `create-pdf-japanese` - Create Japanese-sized cards (Yu-Gi-Oh!)
- `create-pdf-high-quality` - Create high-quality PDF (600 DPI)
- `create-pdf-with-offset` - Create PDF with saved offset calibration
- `offset-pdf` - Apply offset to PDF
- `save-offset` - Save offset calibration
- `clean` - Clean up temporary files
- `calibrate` - Instructions for printer calibration
- `docs` - Start documentation server
- `docs-build` - Build documentation

### Plugin Tasks (Card Fetching)
- `riftbound-fetch-*` - Fetch Riftbound cards (tts, pixelborn, piltover)
- `lorcana-fetch` - Fetch Lorcana cards from Dreamborn
- `mtg-fetch-*` - Fetch MTG cards (mtga, moxfield, scryfall)
- `yugioh-fetch-*` - Fetch Yu-Gi-Oh! cards (ydk, ydke)
- `digimon-fetch-*` - Fetch Digimon cards (tts, digimoncard)
- `onepiece-fetch-*` - Fetch One Piece cards (optsg, egman)
- `fab-fetch-fabrary` - Fetch Flesh and Blood cards
- `ga-fetch-omnideck` - Fetch Grand Archive cards
- `gundam-fetch-*` - Fetch Gundam cards (deckplanet, limitless)
- `altered-fetch-ajordat` - Fetch Altered cards
- `netrunner-fetch-*` - Fetch Netrunner cards (text, jinteki)

### Workflow Tasks
- `riftbound-workflow` - Step-by-step Riftbound instructions
- `lorcana-workflow` - Step-by-step Lorcana instructions
- `mtg-workflow` - Step-by-step MTG instructions

## 🛠️ What This Setup Does

This enhanced setup includes:

- **mise**: Automatically manages Python and Hugo versions
- **direnv**: Automatically activates the environment when you enter the directory
- **Virtual Environment**: Isolated Python environment for dependencies
- **Auto-installation**: Dependencies are installed automatically
- **Directory Structure**: Creates all necessary folders
- **Task Management**: Pre-configured tasks for all common operations
- **Plugin Integration**: Easy-to-use tasks for all supported card games

## 🆘 Troubleshooting

### If the setup script fails:
1. Make sure you have internet connection
2. Try running the script again
3. Check that you're in the correct directory (should contain `create_pdf.py`)

### If direnv doesn't work:
1. Make sure you restarted your terminal
2. Check that direnv is in your PATH: `which direnv`
3. Manually activate: `source .envrc`

### If Python dependencies fail to install:
1. Check Python version: `python --version` (should be 3.11+)
2. Try manual installation: `pip install -r requirements.txt`

### Common Issues:
- **Permission denied**: Run `chmod +x setup.sh` first
- **Command not found**: Make sure you restarted your terminal after setup
- **Port already in use**: Change the Hugo port: `hugo server serve -D --port 1314`

## 📚 More Information

- **Original Project**: [Silhouette Card Maker](https://github.com/Alan-Cha/silhouette-card-maker)
- **Documentation**: [Online Documentation](https://alan-cha.github.io/silhouette-card-maker/)
- **Discord Community**: [Join our Discord](https://discord.gg/jhsKmAgbXc)

## 🎯 Supported Card Sizes

| Card Size | Dimensions (mm) | Games |
|-----------|-----------------|-------|
| Standard | 63 x 88 | Magic: The Gathering, Pokémon, Lorcana |
| Japanese | 59 x 86 | Yu-Gi-Oh! |
| Poker | 63.5 x 88.9 | Standard poker cards |
| Tarot | 69.85 x 120.65 | Tarot cards |

## 📄 Supported Paper Sizes

| Paper Size | Dimensions (mm) |
|------------|-----------------|
| Letter | 215.9 x 279.4 |
| A4 | 210 x 297 |
| A3 | 297 x 420 |
| Tabloid | 279.4 x 431.8 |
| Arch B | 304.8 x 457.2 |

---

**Need help?** Join our [Discord community](https://discord.gg/jhsKmAgbXc) or check the [full documentation](https://alan-cha.github.io/silhouette-card-maker/)!