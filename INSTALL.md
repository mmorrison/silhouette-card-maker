# 🎴 Silhouette Card Maker - One-Liner Installer

The easiest way to get started with Silhouette Card Maker!

## 🚀 Install Everything with One Command

**Copy and paste this command into your terminal:**

```bash
curl -sSL https://raw.githubusercontent.com/Alan-Cha/silhouette-card-maker/main/install.sh | bash
```

## ✨ What This Does

The installer automatically:

1. **Downloads** the project to `~/silhouette-card-maker`
2. **Installs** mise (tool manager) and direnv (environment manager)
3. **Configures** your shell (zsh/bash) for automatic environment activation
4. **Creates** all necessary project directories
5. **Sets up** the Python virtual environment
6. **Installs** all dependencies
7. **Configures** mise tasks for easy card creation

## 🎯 After Installation

1. **Restart your terminal** or run: `source ~/.zshrc` (or `~/.bashrc`)
2. **Navigate to the project**: `cd ~/silhouette-card-maker`
3. **Allow direnv**: `direnv allow`
4. **Start creating cards!**

## 🚀 Quick Examples

```bash
# Get step-by-step instructions for popular games
mise run riftbound-workflow
mise run lorcana-workflow
mise run mtg-workflow

# See all available tasks
mise run help

# Start documentation server
mise run docs
```

## 🛠️ Supported Platforms

- ✅ **macOS** (with or without Homebrew)
- ✅ **Linux** (Ubuntu, Debian, CentOS, Fedora, Arch)
- ❌ **Windows** (use the manual setup instead)

## 🆘 Troubleshooting

### If the installer fails:
1. Make sure you have `git` and `curl` installed
2. Check your internet connection
3. Try running the command again

### If mise/direnv aren't working:
1. Restart your terminal completely
2. Check that they're in your PATH: `which mise` and `which direnv`
3. Manually add them to your shell config if needed

### If you get permission errors:
1. Make sure you have write access to your home directory
2. Try running with `sudo` if necessary (though not recommended)

## 📚 More Information

- **Full Documentation**: [SETUP.md](SETUP.md)
- **Original Project**: [Silhouette Card Maker](https://github.com/Alan-Cha/silhouette-card-maker)
- **Online Documentation**: [alan-cha.github.io/silhouette-card-maker](https://alan-cha.github.io/silhouette-card-maker/)
- **Discord Community**: [Join our Discord](https://discord.gg/jhsKmAgbXc)

---

**Need help?** Join our [Discord community](https://discord.gg/jhsKmAgbXc) or check the [full documentation](https://alan-cha.github.io/silhouette-card-maker/)!