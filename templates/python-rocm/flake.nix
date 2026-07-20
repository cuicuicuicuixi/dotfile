{
  description = "ROCm Python development environment using host ROCm and uv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python312
          uv
        ];

        # ROCm 路径和 GPU 架构从环境变量读取，默认值可被 .envrc.local 覆盖
        ROCM_PATH = builtins.getEnv "ROCM_PATH";
        HSA_OVERRIDE_GFX_VERSION = builtins.getEnv "HSA_OVERRIDE_GFX_VERSION";

        shellHook = ''
          ROCM=''${ROCM_PATH:-/opt/rocm}
          if [ -d "$ROCM" ]; then
            export ROCM_PATH="$ROCM"
            export PATH="$ROCM/bin:$PATH"
            echo "🔴 ROCm: $ROCM_PATH"
          else
            echo "⚠️  ROCm 路径不存在: $ROCM（可编辑 .envrc.local 设置 ROCM_PATH）"
          fi
          if [ -n "$HSA_OVERRIDE_GFX_VERSION" ]; then
            echo "🎯 GPU 架构: $HSA_OVERRIDE_GFX_VERSION"
          fi
          echo "🐍 Python $(python --version) | uv $(uv --version)"
        '';
      };
    };
}
