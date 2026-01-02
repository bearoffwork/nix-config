{ pkgs, ... }:

pkgs.mkShell {
  name = "cuda-dev";

  buildInputs = with pkgs; [
    # CUDA toolkit
    cudatoolkit
    cudaPackages.cudnn

    # Build tools
    gcc
    cmake
    pkg-config

    # Common ML/AI tools
    python311
    python311Packages.pip
    python311Packages.virtualenv
  ];

  shellHook = ''
    # Add WSL NVIDIA libraries to library path
    export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.cudatoolkit}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH

    # CUDA environment variables
    export CUDA_PATH=${pkgs.cudatoolkit}
    export CUDA_HOME=${pkgs.cudatoolkit}
    export EXTRA_LDFLAGS="-L/usr/lib/wsl/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I${pkgs.cudatoolkit}/include"

    echo "CUDA Development Shell"
    echo "CUDA Version: $(nvcc --version | grep release | awk '{print $6}')"
    echo "LD_LIBRARY_PATH includes WSL NVIDIA drivers"
  '';
}
