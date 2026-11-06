{
  description = "Illogical Impulse - Home-manager module for end-4's Hyprland dotfiles with QuickShell";

  inputs = {
    # These will be overridden by the user's flake
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Default dotfiles - can be overridden by users
    dotfiles = {
      url = "git+https://github.com/end-4/dots-hyprland?submodules=1";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nur, dotfiles, ... }:
    let
      flakeInputs = { inherit nur dotfiles; };
    in {
      # Home-manager module for user configuration
      homeManagerModules.default = { config, lib, pkgs, ... }: (import ./home-module.nix) {
        inherit config lib pkgs;
        inputs = flakeInputs;
      };
      homeManagerModules.illogical-flake = self.homeManagerModules.default;
    };
}
