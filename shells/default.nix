{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "infra-shell";
      packages = with pkgs; [
        colmena
      ];
    };
  };
}
