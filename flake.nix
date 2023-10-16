{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.ripgrep = pkgs.ripgrep;
      packages.git = pkgs.git;
      packages.fd = pkgs.fd;
      packages.neovim = pkgs.neovim;
      packages.lazygit = pkgs.lazygit;
      packages.default = pkgs.neovim;
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python311
          ripgrep
          git
          lazygit
          fd
          neovim
        ];
        modules = [
          ./config
        ];
        shellHook = ''
        echo "Python devshell activated."
        echo "Running 3.11 with rg, git, lazygit."
        export XDG_CONFIG_HOME="${self}/config/"
        nvim
        '';
      };
    });
}
