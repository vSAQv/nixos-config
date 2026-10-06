# NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-unstable-5277C3?style=flat-square\&logo=nixos\&logoColor=white)](https://nixos.org/)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-declarative-7EBAE7?style=flat-square\&logo=nixos\&logoColor=white)](https://github.com/nix-community/home-manager)
[![License](https://img.shields.io/badge/license-MIT-98971A?style=flat-square)](./LICENSE)

Personal **NixOS configuration** built around a flake-based, modular architecture.

The repository defines several host profiles, a shared system layer, a declarative desktop environment, development tooling, gaming support, and a small homelab stack. It is designed around the idea that the operating system itself should be treated as code: configuration is split into reusable modules, host-specific differences are isolated, and system changes are applied through Nix rather than maintained manually.

The project originally started from **Frost-Phoenix's NixOS configuration**. Since the initial snapshot, it has been progressively reworked around my own hardware, workflow, desktop environment, AI tooling, and homelab infrastructure.

> **Status:** personal configuration, not a generic NixOS distribution or a drop-in configuration. Some modules are intentionally tied to my hardware and local infrastructure.

---

## Highlights

| Area               | What is configured                                                                      |
| :----------------- | :-------------------------------------------------------------------------------------- |
| **OS**             | NixOS + Flakes + `nixos-unstable`                                                       |
| **Configuration**  | Modular NixOS + Home Manager setup                                                      |
| **Hosts**          | Desktop, laptop, and KVM/QEMU VM profiles                                               |
| **Desktop**        | Hyprland, Waybar, SwayNC, Rofi, Hyprlock, Wayland portals                               |
| **Terminal**       | Zsh, Powerlevel10k, fzf-tab, custom aliases/scripts                                     |
| **Editor**         | Neovim configured through `nvf`, LSP, Treesitter, DAP, Telescope, Git integration       |
| **Development**    | `direnv`, `nix-direnv`, `devenv`, Git, CLI tooling                                      |
| **AI tooling**     | OpenCode integration, declarative workspace wrappers, OpenRouter secret provisioning    |
| **Gaming**         | Steam, Gamescope, Proton-GE, RetroArch                                                  |
| **GPU / media**    | NVIDIA + Intel graphics support, PRIME offload, hardware acceleration                   |
| **Audio**          | PipeWire, WirePlumber, Bluetooth enhancements, high-quality resampling                  |
| **Networking**     | NetworkManager, Tailscale, OpenSSH, Mosh, Clash Verge TUN mode                          |
| **Virtualization** | Docker (rootless), Podman cleanup, libvirt/QEMU tooling                                 |
| **Homelab**        | K3s, external containerd, NVIDIA Container Toolkit, Argo CD, SOPS                       |
| **Maintenance**    | Nix GC, store optimization, `/tmp` cleanup, container pruning, journal retention limits |
| **Reliability**    | Battery emergency-shutdown watchdog for low-power scenarios                             |
| **Aesthetic**      | Gruvbox-oriented UI, custom wallpapers, Waybar modules and shell theming                |

---

## Architecture

The configuration is split into three main layers:

```text
flake.nix
│
├── nixosConfigurations
│   ├── desktop
│   │   └── hosts/desktop
│   ├── laptop
│   │   └── hosts/laptop
│   └── vm
│       └── hosts/vm
│
├── modules/core
│   ├── boot
│   ├── hardware
│   ├── networking
│   ├── audio
│   ├── services
│   ├── security
│   ├── virtualization
│   ├── storage maintenance
│   ├── battery protection
│   └── homelab
│
└── modules/home
    ├── Hyprland
    ├── Waybar
    ├── Zsh / Powerlevel10k
    ├── Neovim
    ├── applications
    ├── scripts
    └── AI tooling
```

The `flake.nix` defines shared inputs and three NixOS configurations. Each host imports the shared `modules/core` layer and provides only the hardware- or machine-specific differences. Home Manager is integrated from the core user module and selects the appropriate home configuration based on the host name.

### Design goals

**Declarative configuration**

System services, packages, user applications, shell configuration, desktop settings, and infrastructure integrations are represented as Nix modules.

**Modularity**

Reusable functionality lives under `modules/core` and `modules/home`, while `hosts/*` contains the parts that genuinely depend on a specific machine.

**Hardware-aware configuration**

The desktop and laptop profiles use different kernel and power policies while sharing the same core system architecture.

**Reproducibility**

Flake inputs are pinned through `flake.lock`, and system changes are applied as NixOS generations rather than as a collection of hand-edited files.

---

## Hosts

### `desktop`

Primary desktop profile.

Notable characteristics:

* CachyOS kernel package through the `chaotic` input.
* Performance-oriented CPU frequency policy.
* Shared NVIDIA configuration with PRIME offload.
* Full Wayland / Hyprland environment.
* Gaming stack with Steam, Gamescope and Proton-GE.
* Desktop-specific monitoring and disk information in Waybar.

### `laptop`

Power- and thermal-aware laptop profile.

Notable characteristics:

* CachyOS kernel package.
* `power-profiles-daemon` with an explicit power-saver profile at boot.
* `thermald` and `powertop`.
* `undervolt` configuration with separate long- and short-duration power limits.
* ACPI-related kernel support.
* Power-saving kernel parameters.
* Shared battery emergency-shutdown protection from `modules/core/battery-shutdown.nix`.

### `vm`

KVM/QEMU-oriented profile.

Notable characteristics:

* QEMU guest hardware configuration.
* GRUB instead of systemd-boot for the VM profile.
* Latest Linux kernel package.
* SSH enabled for convenient remote access while experimenting with the system.

---

## Core System Configuration

The `modules/core` layer provides the system-wide foundation shared by all hosts.

### Boot and hardware

The configuration uses systemd-boot on physical systems, while the VM overrides this with GRUB. Hardware support includes:

* NVIDIA drivers with open kernel modules.
* NVIDIA PRIME render offload.
* Intel graphics acceleration packages.
* NVIDIA Container Toolkit.
* Bluetooth and Blueman.
* Intel CPU microcode.
* CachyOS kernel packages on desktop and laptop systems.

### Networking

The network layer configures:

* NetworkManager.
* Static DNS resolvers.
* Firewall rules and trusted interfaces.
* Tailscale.
* Mosh.
* OpenSSH.
* Clash Verge with service and TUN mode.
* Local network services such as LocalSend.

The host name is derived from the selected flake configuration, keeping host identity declarative as well.

### Audio

PipeWire replaces PulseAudio and is configured with:

* ALSA and 32-bit ALSA support.
* Pulse compatibility.
* WirePlumber.
* Bluetooth enhancements.
* LDAC as the preferred Bluetooth codec.
* Multiple allowed sample rates: `44.1`, `48`, `88.2`, `96`, and `192 kHz`.
* High-quality Speex resampling.

Additional desktop audio tools include `pavucontrol` and Strawberry.

### Virtualization

The shared virtualization layer provides:

* Docker with rootless mode.
* libvirt/QEMU support.
* `virt-manager`.
* SPICE tooling and USB redirection.
* Windows virtio/SPICE packages.
* Automatic Docker and Podman cleanup.

The K3s homelab configuration additionally integrates the host's containerd runtime with the NVIDIA container runtime.

---

## Desktop Environment

The user environment is centered around **Hyprland** and follows a deliberately minimal Gruvbox-inspired aesthetic.

### Hyprland

The Hyprland setup includes:

* Wayland-first configuration.
* XWayland.
* Systemd integration.
* `dwindle` layout.
* Minimal window decorations with no borders.
* Custom blur and shadow behavior.
* Workspace automation.
* Screenshot and clipboard workflows.
* Application launchers and utility shortcuts.
* Power-profile switching from Hyprland keybinds.
* Wallpaper selection and background management.
* Automatic startup of Waybar, SwayNC, clipboard persistence, power alerts and other session tools.

### Waybar

Waybar is split into declarative settings and styling modules.

The bar includes:

* Hyprland workspaces.
* Keyboard layout indicator.
* System tray.
* Active window name.
* Centered clock.
* CPU and memory usage.
* Disk usage on the desktop.
* Battery status.
* Audio status.
* Notifications.
* Dynamic weather.
* Cava-based audio visualization.

The weather widget performs a live `wttr.in` lookup and displays a three-day forecast in its tooltip. Startup handling was also refined so the widget does not immediately show `N/A` when networking is not ready yet.

### Shell

The shell environment uses:

* Zsh.
* Powerlevel10k.
* `fzf-tab`.
* Custom completion behavior.
* Git- and environment-aware prompt segments.
* Nix, Kubernetes, Docker and development-context indicators.
* Custom shell aliases and keybindings.
* Personal utility scripts for wallpapers, recording, power management, compression, extraction and window/session control.

### Neovim

Neovim is configured declaratively through [`nvf`](https://github.com/NotAShelf/nvf).

The configuration currently includes:

* Gruvbox dark theme.
* Lualine.
* Telescope.
* `nvim-cmp`.
* Treesitter.
* LSP with format-on-save.
* Tailwind CSS language server integration.
* `nvim-dap` debugging and UI.
* LuaSnip.
* Autopairs.
* Neo-tree.
* Git integration.
* WhichKey.
* `yazi.nvim`.
* Telescope Zoxide integration.
* CodeCompanion with Anthropic adapters.
* Language support for Bash, TypeScript, HTML, CSS, Python, Rust, Nix and Lua.

---

## Development Environment

The development workflow is integrated into the operating-system configuration rather than being maintained as a separate machine setup.

Relevant tooling includes:

* `git` and `lazygit`.
* `ripgrep`, `fd`, `fzf` and `eza`.
* `direnv` / `nix-direnv`.
* `devenv`.
* Python and IPython.
* `repomix` for packaging repository context for AI tooling.
* Nix formatting through `alejandra`.
* `nix-ld` for software that expects a more conventional runtime environment.

The repository also keeps several development-oriented utilities available through the shared package module, allowing the workstation environment to be recreated from the same configuration.

---

## AI Tooling

AI-assisted development became an explicit part of the configuration during the later stages of the project.

### OpenCode

OpenCode is configured as a Home Manager module with a declarative wrapper around the executable.

The wrapper:

1. Reads the OpenRouter API key from the SOPS-provisioned runtime secret.
2. Sets the OpenCode configuration directory to the AI workspace.
3. Exposes the Nix-selected Python interpreter through `AI_WORKSPACE_PYTHON`.
4. Launches the packaged OpenCode binary.

The same module also installs:

```text
workspace
workspace-validate
workspace-test
```

These commands provide a common entry point for the local AI workspace and its validation/test workflow.

A user-level systemd service launches the OpenCode Web UI bound to localhost on port `4096`.

### Aider

Aider support is also present in the repository, including a declarative configuration for OpenRouter-backed models, architect mode, linting and project rules.

The Aider module is currently disabled in the main Home Manager import list, so it is retained as optional tooling rather than enabled by default.

---

## Homelab

One of the largest changes after the original configuration was turning the workstation configuration into a declarative entry point for a personal homelab.

The homelab layer lives under:

```text
modules/core/homeLab/
├── declaration.nix
├── default.nix
├── k3s.nix
├── secrets.yaml
└── sync.nix
```

### K3s

The current configuration runs **K3s as a server** and uses the host-managed containerd runtime.

The setup includes:

* Declarative K3s server configuration.
* External NixOS-managed containerd.
* Explicit CNI path alignment between K3s and containerd.
* NVIDIA Container Toolkit integration.
* NVIDIA runtime configuration.
* Kubelet storage-pressure and image-GC policies.
* SSD-aware image-pull behavior.
* Graceful K3s shutdown handling.
* Argo CD bootstrap manifests.
* GitOps root application configuration.

The use of host containerd is particularly important for the NVIDIA runtime integration: instead of relying on K3s's embedded containerd configuration, the repository configures containerd through NixOS and points K3s at the host socket.

### GitOps bootstrap

K3s bootstrap creates the required manifest directory and declaratively prepares:

* Argo CD.
* A GitOps root application.
* The homelab Kubernetes secret generated from SOPS data.

Argo CD is configured to recursively synchronize the `apps` directory of the homelab Kubernetes repository.

### Homelab storage

`declaration.nix` defines the directory hierarchy under:

```text
~/homelab/
├── config/
└── data/
```

The structure includes dedicated locations for:

* Media libraries.
* Audiobooks.
* Books and ebooks.
* Manga.
* Movies and TV.
* Music.
* Photos.
* Torrents.
* Game/server data.
* Application configuration.
* Job Finder data.
* OpenObserve data.

Directories are created through `systemd.tmpfiles` rules, keeping storage layout declarative.

### Backups

`sync.nix` contains a Restic backup definition for application state such as:

* Audiobookshelf.
* Readarr.
* Jellyfin.
* Jellyseerr.
* Radarr.
* Sonarr.
* Syncthing.
* Filebrowser.
* Navidrome.
* slskd.
* Kavita.
* Job Finder.

The module is currently not imported by `homeLab/default.nix`, so this backup definition is present but not active in the current default configuration.

---

## Secrets Management

Secrets are managed with **SOPS** and **age** rather than being stored in plaintext.

The main encrypted secret store is:

```text
modules/core/homeLab/secrets.yaml
```

The SOPS policy is defined in:

```text
.sops.yaml
```

The K3s configuration declares the required secrets and renders them into a Kubernetes `Secret` manifest through a SOPS template.

The same mechanism is also used by the OpenCode wrapper to obtain the OpenRouter API key at runtime.

### Important

The committed `secrets.yaml` is encrypted, but the configuration itself is still tied to the current age recipients and local infrastructure.

Before reusing this repository on another machine:

* Replace the SOPS/age recipients with your own keys.
* Replace the encrypted secret values.
* Review host-specific filesystem paths.
* Review homelab GitOps URLs and infrastructure settings.
* Review any machine-specific network configuration.

Never commit decrypted secrets to Git.

---

## Storage and Reliability

The configuration contains several small reliability features that are easy to overlook but are important in long-running systems.

### Automated storage maintenance

The storage optimization module configures:

* Weekly Nix garbage collection.
* Removal of Nix generations older than 14 days during GC.
* Automatic Nix store optimization through hardlinks.
* Boot-time `/tmp` cleanup.
* Weekly Docker pruning.
* Weekly Podman pruning.
* A maximum systemd journal size of `1 GB`.
* A maximum journal retention of one month.

### Battery emergency protection

`battery-shutdown.nix` adds a separate systemd watchdog for low-battery conditions.

The policy is:

| Threshold             | Action                                   |
| :-------------------- | :--------------------------------------- |
| `30%`                 | Low battery level                        |
| `25%`                 | Critical battery level                   |
| `20%`                 | Emergency watchdog becomes active        |
| `5%`                  | Immediate poweroff                       |
| `20% or less for 60s` | Poweroff after continuous critical state |

The watchdog checks the actual kernel battery interface and also verifies whether external power is available. It is executed periodically by a systemd timer rather than relying exclusively on desktop power-management behavior.

---

## Common Commands

Build or switch to a configuration directly from the flake:

```bash
sudo nixos-rebuild switch --flake .#desktop
```

```bash
sudo nixos-rebuild switch --flake .#laptop
```

```bash
sudo nixos-rebuild switch --flake .#vm
```

After the system is installed, [`nh`](https://github.com/viperML/nh) is also configured for this repository:

```text
/home/<username>/nixos-config
```

The configuration keeps five generations in addition to a seven-day retention window for automatic cleanup.

---

## Installation

This repository is hardware-specific, so the safest installation path is to adapt the configuration rather than blindly applying it.

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd nixos-config
```

### 2. Select your username

The flake currently defines the system user centrally. Update the `username` value in `flake.nix` before the first activation.

### 3. Generate host hardware configuration

On the target NixOS machine:

```bash
sudo nixos-generate-config
```

Copy the generated hardware configuration into the appropriate host directory:

```text
hosts/desktop/hardware-configuration.nix
hosts/laptop/hardware-configuration.nix
hosts/vm/hardware-configuration.nix
```

### 4. Review hardware-specific modules

At minimum, review:

```text
hosts/<host>/default.nix
modules/core/hardware.nix
modules/core/windows/shared.nix
modules/core/homeLab/
```

These contain hardware, storage, GPU, network and infrastructure assumptions that are specific to the original environment.

### 5. Build the system

```bash
sudo nixos-rebuild switch --flake .#<host>
```

Replace `<host>` with `desktop`, `laptop`, or `vm`.

### About `install.sh`

The repository contains an `install.sh` inherited from the early Frost-Phoenix-based setup. It still contains legacy assumptions from the original configuration, including the original username replacement logic.

For the current version of the repository, the flake-based installation path above is the canonical approach.

---

## Repository Layout

```text
.
├── hosts/
│   ├── desktop/
│   ├── laptop/
│   └── vm/
│
├── modules/
│   ├── core/
│   │   ├── homeLab/
│   │   ├── windows/
│   │   ├── battery-shutdown.nix
│   │   ├── bootloader.nix
│   │   ├── hardware.nix
│   │   ├── network.nix
│   │   ├── nh.nix
│   │   ├── pipewire.nix
│   │   ├── program.nix
│   │   ├── security.nix
│   │   ├── services.nix
│   │   ├── steam.nix
│   │   ├── storage-optimization.nix
│   │   ├── system.nix
│   │   ├── user.nix
│   │   ├── virtualization.nix
│   │   ├── wayland.nix
│   │   └── xserver.nix
│   │
│   └── home/
│       ├── hyprland/
│       ├── opencode/
│       ├── p10k/
│       ├── scripts/
│       ├── swaync/
│       ├── waybar/
│       ├── zsh/
│       └── application modules...
│
├── pkgs/
│   ├── 2048/
│   └── monolisa/
│
├── wallpapers/
│
├── .sops.yaml
├── flake.nix
├── flake.lock
├── install.sh
├── LICENSE
└── README.md
```

---

## Evolution

The initial configuration is deliberately treated here as the **starting point**, not as the description of the current repository.

The project started on **May 30, 2026** from a NixOS configuration based on **Frost-Phoenix's work**. The subsequent development focused on turning that base into a personal, modular system with its own hardware profiles, desktop workflow, homelab, security tooling and AI-assisted development environment.

### Selected milestones

| Date                   | Area              | Change                                                                                                                      |
| :--------------------- | :---------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| **2026-06-01**         | Kernel            | Switched the core setup to CachyOS kernel packages for desktop/laptop use.                                                  |
| **2026-06-02**         | Hardware / power  | Added Intel-related tuning, undervolting and explicit performance/power workflows.                                          |
| **2026-06-09**         | Tooling           | Added repository-analysis tooling such as Repomix and remote-support tooling such as RustDesk.                              |
| **2026-06-16 – 06-17** | Desktop           | Refined Hyprland visuals and substantially expanded Waybar with weather, language, Cava and active-window information.      |
| **2026-06-21**         | Storage           | Added declarative mounting for the shared NTFS partition used with Windows.                                                 |
| **2026-06-24**         | Homelab           | Introduced a declarative home-server layer for storage layout and service orchestration.                                    |
| **2026-06-29**         | Infrastructure    | Replaced the previous Docker-oriented homelab approach with K3s and added the SOPS foundation.                              |
| **2026-07-06**         | Secrets / GitOps  | Added encrypted secrets, SOPS integration and homelab secret provisioning.                                                  |
| **2026-07-11 – 07-21** | Development / AI  | Added `devenv`, `direnv`, Aider configuration and model-routing workflows.                                                  |
| **2026-07-22 – 07-28** | Kubernetes / GPU  | Added K3s image-GC policies, SSD-aware image pulling and migrated K3s to host containerd for native NVIDIA runtime support. |
| **2026-08-20**         | Desktop utilities | Added LocalSend and corresponding firewall rules.                                                                           |
| **2026-08-31**         | Services          | Added `usbmuxd` and further corrected K3s/containerd CNI integration.                                                       |
| **2026-09-01**         | Maintenance       | Added deterministic Nix, Docker, Podman, `/tmp` and journal maintenance policies.                                           |
| **2026-09-04**         | Reliability       | Added dedicated low-battery emergency shutdown protection.                                                                  |
| **2026-09-06 – 09-08** | AI tooling        | Added OpenCode, local Web UI support and declarative workspace/test/validation wrappers.                                    |
| **2026-09-13**         | Homelab / music   | Added ListenBrainz and Navidrome credentials to the homelab secret pipeline.                                                |

This history is the most important distinction between the original base configuration and the repository as it exists today: the project gradually moved from a personal desktop configuration toward a broader **declarative workstation + development environment + homelab control plane**.

---

## Acknowledgements

Special thanks to **[Frost-Phoenix](https://github.com/Frost-Phoenix)**.

This repository started from his NixOS configuration, which provided the foundation for the early setup. He also helped me become comfortable with NixOS during the initial stages of working with the distribution.

The current repository should be understood as a continuation and personal reworking of that foundation rather than as a mirror of the original project. The host structure, later modules, homelab architecture, AI tooling, hardware-specific tuning and most of the subsequent evolution were developed for my own environment.

---

## License

This project is licensed under the **MIT License**.

See [`LICENSE`](./LICENSE) for the full license text.

The repository retains the original copyright notice for Frost-Phoenix together with the later copyright notice for the current project.

