{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "infra-shell";
        packages = with pkgs; [
          colmena
        ];
      };

      # devshell to compile https://github.com/muradbu/XGDTool
      devShells.xgdtool = pkgs.mkShell {

        # Tools needed to build the project
        nativeBuildInputs = with pkgs; [
          pkg-config
          cmake
          gnumake
        ];

        # Libraries needed for linking
        buildInputs = with pkgs; [
          lz4
          zstd
          openssl
          curl
          wxwidgets_3_2
        ];

        # Optional: A welcome message when you enter the shell
        shellHook = ''
          echo "C/C++ development shell active."
          echo "Compiler toolchain, CMake, and wxWidgets are ready."
        '';
      };
    };
}
