# NVIDIA GPU Support on NixOS WSL2

## Overview

This NixOS configuration enables NVIDIA GPU access in Podman containers on WSL2 using Container Device Interface (CDI).

## Configuration Files

- `hosts/bench/nvidia.nix` - NVIDIA driver and CDI configuration
- `hosts/bench/docker.nix` - Podman setup with Docker compatibility

## Key Configuration Details

### NVIDIA Setup (`hosts/bench/nvidia.nix`)

**Driver Configuration:**
- Uses open-source NVIDIA drivers: `hardware.nvidia.open = true`
- Video driver: `services.xserver.videoDrivers = [ "nvidia" ]`

**Environment Variables:**
- `LD_LIBRARY_PATH` includes `/usr/lib/wsl/lib` for WSL NVIDIA libraries
- `MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia"` for Mesa D3D12 support

**Container Toolkit:**
```nix
hardware.nvidia-container-toolkit = {
  enable = true;
  mount-nvidia-executables = false;  # Critical for WSL2
};
```

**CDI Generation Service:**
- Automatically generates `/etc/cdi/nvidia.yaml` on boot
- Uses `nvidia-ctk` to detect WSL2 environment and configure GPU access
- Key parameters:
  - `--library-search-path=/usr/lib/wsl/lib` - WSL NVIDIA library location
  - `--nvidia-ctk-path` - Path to nvidia-ctk binary for hooks
  - Environment: `LD_LIBRARY_PATH=/usr/lib/wsl/lib` for library detection

### Podman Setup (`hosts/bench/docker.nix`)

- Rootless Podman with Docker compatibility
- Docker socket enabled for Docker Compose compatibility
- CDI automatically detected by Podman

## Usage

### Native GPU Development with Nix Devshells

For native GPU development (like building llama.cpp with CUDA), use the provided devshells:

**CUDA Development Shell:**
```bash
nix develop .#cuda
```

**llama.cpp Development Shell:**
```bash
nix develop .#llama
```

These shells include:
- CUDA toolkit and libraries
- Proper `LD_LIBRARY_PATH` pointing to WSL NVIDIA drivers
- Build tools (gcc, cmake, pkg-config)
- Environment variables for CUDA compilation

**Example: Building llama.cpp with CUDA**
```bash
nix develop .#llama
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make GGML_CUDA=1
```

### Running Containers with GPU

Use the CDI device specification to access GPU:

```bash
podman run --rm --device nvidia.com/gpu=all ubuntu nvidia-smi
```

Or with Docker compatibility:

```bash
docker run --rm --device nvidia.com/gpu=all ubuntu nvidia-smi
```

### Docker Compose

In `docker-compose.yml`:

```yaml
services:
  my-service:
    image: nvidia/cuda:12.0.0-base-ubuntu22.04
    devices:
      - nvidia.com/gpu=all
    command: nvidia-smi
```

## Important Notes

### WSL-Specific Behavior

1. **Native nvidia-smi doesn't work**: The `nvidia-smi` binary from Nix won't run directly on NixOS WSL2. Use `nvidia-smi.exe` (Windows executable) from the host or run `nvidia-smi` inside containers.

2. **Driver Location**: NVIDIA drivers are in `/usr/lib/wsl/lib/` and `/usr/lib/wsl/drivers/nv_dispig.inf_amd64_*/` (WSL-provided paths, not Nix-managed)

3. **CDI Auto-Detection**: The nvidia-ctk tool automatically detects WSL2 mode and configures appropriate device paths (`/dev/dxg`)

### Rootless Podman Considerations

- Containers run as unprivileged user
- Socket location: `/run/user/{uid}/podman/podman.sock` (not `/run/podman/podman.sock`)
- Docker compatibility layer maps `docker` commands to `podman`

### Selective Unfree Policy

This configuration uses `allowUnfreePredicate` instead of global `allowUnfree`:
- Only explicitly listed NVIDIA/CUDA packages are allowed using prefix matching
- Prevents accidental inclusion of other unfree packages
- More transparent about unfree dependencies
- Pattern matching allows for version-independent package acceptance

**Allowed unfree package patterns:**
- `cudatoolkit*` - CUDA development toolkit
- `cuda-merged*` - Merged CUDA packages
- `cudnn*` - CUDA Deep Neural Network library
- `nvidia-x11*` - NVIDIA X11 drivers (includes versioned packages)
- `nvidia*` - All NVIDIA-related packages (docker, settings, persistenced, etc.)

**Configuration location:** `hosts/bench/default.nix:27`

## Troubleshooting

### Check CDI file exists
```bash
ls -lh /etc/cdi/nvidia.yaml
```

### Verify CDI service
```bash
sudo systemctl status nvidia-cdi-generator.service
```

### Manual CDI regeneration
```bash
sudo LD_LIBRARY_PATH=/usr/lib/wsl/lib nvidia-ctk cdi generate \
  --output=/etc/cdi/nvidia.yaml \
  --library-search-path=/usr/lib/wsl/lib \
  --nvidia-ctk-path=$(which nvidia-ctk)
```

### Test GPU access
```bash
podman run --rm --device nvidia.com/gpu=all ubuntu nvidia-smi
```

## References

- [NixOS-WSL NVIDIA Issue #578](https://github.com/nix-community/NixOS-WSL/issues/578) - mount-nvidia-executables setting
- [NixOS-WSL NVIDIA Issue #454](https://github.com/nix-community/NixOS-WSL/issues/454) - LD_LIBRARY_PATH requirements
- [Blog: NVIDIA on NixOS WSL](https://yomaq.github.io/posts/nvidia-on-nixos-wsl-ollama-up-24-7-on-your-gaming-pc/) - Original configuration source
- [Container Device Interface (CDI) Spec](https://github.com/cncf-tags/container-device-interface)

## Current Status

✅ NVIDIA GPU accessible in Podman containers via CDI
✅ Automatic CDI generation on system boot
✅ Compatible with rootless Podman
✅ Docker Compose support via compatibility layer
