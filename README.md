# Emacs Configuration

This repository contains a cross-platform `.emacs` configuration file.

## Setup Instructions

### Linux & macOS
Run the bash script to link the `.emacs` file to your home directory:
```bash
chmod +x link_emacs.sh
./link_emacs.sh
```

### Windows
Run the PowerShell script to link the `.emacs` file to your user profile directory:
```powershell
.\link_emacs.ps1
```

## Prerequisites
- **Emacs**: Installed on the system.
- **Fonts**: The configuration uses `Hasklig` (with ligatures).
- **Windows Spellcheck**: Expects `hunspell` at `C:\msys64\mingw64\bin\hunspell.exe`.
- **Packages**: Uses `use-package` and `straight.el` (or standard package.el with MELPA).

## Troubleshooting (Windows)
If you encounter permission errors when running the PowerShell script:
1. **Developer Mode**: Enable "Developer Mode" in Windows Settings to allow symbolic links without Administrator privileges.
2. **Execution Policy**: If scripts are disabled, run: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` before running the script.
