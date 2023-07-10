{
  description = "flakes power";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    home-manager.url = "github:nix-community/home-manager";
    nix-gaming.url = "github:fufexan/nix-gaming";
    patched-fonts = {
      url = "github:40huo/Patched-Fonts";
      flake = false;
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # use devenv to manage my development environment
    # devenv.url = "github:cachix/devenv/v0.6.2";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixpkgs-f2k, lanzaboote, nix-gaming, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      config.allowUnfree = true;
    in
    {
      nixosConfigurations = {
        io = inputs.nixpkgs.lib.nixosSystem {

          specialArgs = { inherit inputs; inherit unstable; };
          modules = [
            ./hosts/io/configuration.nix
            ./hosts/shared
            ./hosts/shared/gaming
	          ./hosts/shared/blocker
            ./home/shared

          
          # lanzaboote.nixosModules.lanzaboote
          # ({ pkgs, lib, ... }: {
          #     boot.bootspec.enable = true;
          #     environment.systemPackages = [
          #       pkgs.sbctl
          #     ];
          #     boot.loader.systemd-boot.enable = lib.mkForce false;
          #     boot.lanzaboote = {
          #       enable = true;
          #       pkiBundle = "/etc/secureboot";
          #     };
          # })

          {
            nixpkgs.overlays = [
              # nixpkgs-f2k.overlays.compositors
              # nixpkgs-f2k.overlays.window-managers
              nixpkgs-f2k.overlays.stdenvs

              (final: _:
                let
                  inherit (final) system;
                in
                {
                  patched-fonts = pkgs.callPackage ./derivations/patched-fonts.nix {
                    src = inputs.patched-fonts;
                  };
                })
            ];
          }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; inherit unstable; };
                users.mario = ./home/io/mario/home.nix;
              };
            }
          ];
        };
      };
    };
}
