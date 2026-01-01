{ pkgs, ... }:

pkgs.mkShell {
  name = "llama-cpp-cuda";

  buildInputs = with pkgs; [
    # CUDA support
    cudatoolkit
    cudaPackages.cudnn

    # Build dependencies for llama.cpp
    gcc
    cmake
    pkg-config
    git

    # Optional: Python for running scripts
    python311
    python311Packages.numpy
    python311Packages.sentencepiece
  ];

  shellHook = ''
    # WSL NVIDIA library path
    export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.cudatoolkit}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH

    # CUDA configuration
    export CUDA_PATH=${pkgs.cudatoolkit}
    export CUDA_HOME=${pkgs.cudatoolkit}

    # llama.cpp build flags for CUDA
    export CMAKE_ARGS="-DGGML_CUDA=ON -DCUDA_TOOLKIT_ROOT_DIR=${pkgs.cudatoolkit}"
    export GGML_CUDA=1

    echo "========================================="
    echo "llama.cpp CUDA Development Shell"
    echo "========================================="
    echo ""
    echo "Build llama.cpp with CUDA:"
    echo "  git clone https://github.com/ggerganov/llama.cpp"
    echo "  cd llama.cpp"
    echo "  make GGML_CUDA=1"
    echo ""
    echo "Or use cmake:"
    echo "  cmake -B build -DGGML_CUDA=ON"
    echo "  cmake --build build --config Release"
    echo ""
    echo "Test GPU access:"
    echo "  nvidia-smi.exe"
    echo "========================================="
  '';
}
