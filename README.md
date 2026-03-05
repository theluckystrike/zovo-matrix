<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-00cc00?style=flat-square&logo=apple&logoColor=00cc00" alt="macOS">
  <img src="https://img.shields.io/badge/shell-zsh-00cc00?style=flat-square" alt="zsh">
  <img src="https://img.shields.io/badge/license-MIT-00cc00?style=flat-square" alt="MIT License">
  <img src="https://img.shields.io/github/stars/theluckystrike/zovo-matrix?style=flat-square&color=00cc00" alt="Stars">
</p>

```
 ______   ___   ___  __    ___       __   __        __  ___  ____  ____  _  _
|__  / _ \\ \\ / / _ \\|  \\  /  |  /\\  |__) |__) | \\_/
  / / |_| |\\ V /| |_| |   \\/   | /  \\ |  \\ | \\  | / \\
 /__|\\___/  \\_/ |\\___/|_|\\/\\_| /    \\|  \\ |  \\ |/   \\
```

# ZOVO MATRIX

### Transform your terminal into The Matrix

> A fully-themed Matrix terminal environment for macOS and zsh. Black backgrounds, green phosphor text, cascading code rain, and a hacker-aesthetic prompt — all configured and ready to deploy.

---

![Screenshot](screenshots/preview.png)

> **Note:** Add your terminal screenshots to a `screenshots/` directory in the project root.

---

## Features

- **Black background, Matrix green text** — Full terminal color scheme built around `#00FF00` on pure black
- **Powerlevel10k prompt** — Custom green hacker-aesthetic prompt configuration
- **Matrix MOTD welcome screen** — Randomized quotes from The Matrix displayed on every new session
- **Syntax highlighting in green** — zsh-syntax-highlighting themed to match the Matrix palette
- **Autosuggestions in dim green** — Subtle inline completions that stay on-brand
- **fastfetch system info** — Green-themed system information dashboard
- **cmatrix rain animation** — Classic cascading Matrix code rain, one command away
- **Utility commands** — Purpose-built tools: `neo`, `decode`, `scan`, `tree-scan`
- **Privacy Shield Chrome extension** — Browser-side privacy hardening, included in the repo

---

## Quick Install

```bash
git clone https://github.com/theluckystrike/zovo-matrix.git
cd zovo-matrix
chmod +x install.sh
./install.sh
```

The installer will back up your existing configuration before making any changes.

---

## Commands

| Command | Description |
|-------------|------------------------------------------------------|
| `matrix` | Launch the Matrix rain animation (cmatrix) |
| `neo` | Open the system dashboard |
| `decode` | Decode-style text animation effect |
| `scan` | Network/system scan with Matrix-styled output |
| `tree-scan` | Directory tree with green Matrix formatting |
| `fastfetch` | Display system info in green-themed layout |

---

## Chrome Extension — Privacy Shield

The repository includes **Privacy Shield**, a lightweight Chrome extension that hardens your browser's privacy settings.

### Installation

1. Open Chrome and navigate to `chrome://extensions`
2. Enable **Developer mode** (toggle in the top-right corner)
3. Click **Load unpacked**
4. Select the `chrome-extension/` directory from this repository

Privacy Shield blocks common tracking mechanisms and integrates visually with the Matrix green theme.

---

## Requirements

| Dependency | Purpose |
|-----------------|----------------------------------------|
| **macOS** | Target platform |
| **zsh** | Shell (default on macOS) |
| **Oh My Zsh** | Plugin and theme framework |
| **Powerlevel10k** | Prompt theme |
| **Homebrew** | Package manager for dependencies |

The install script will check for these dependencies and guide you through any missing setup.

---

## Built by Zovo

**[zovo.one](https://zovo.one)** — Building tools for developers who care about privacy, performance, and beautiful interfaces.

This project is part of the Zovo open-source ecosystem.

[![Website](https://img.shields.io/badge/zovo.one-Visit-00cc00?style=for-the-badge)](https://zovo.one)
[![GitHub](https://img.shields.io/badge/GitHub-theluckystrike-00cc00?style=for-the-badge&logo=github)](https://github.com/theluckystrike)

---

## Contributing

Contributions are welcome. To get started:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m "Add your feature"`)
4. Push to your branch (`git push origin feature/your-feature`)
5. Open a Pull Request

Please ensure your changes are consistent with the Matrix green theme and follow the existing code style.

---

## License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>There is no spoon.</sub>
</p>
