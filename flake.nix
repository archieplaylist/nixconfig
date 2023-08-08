{
  description = "flakes power";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    patched-fonts = {
      url = "github:40huo/Patched-Fonts";
      flake = false;
    };
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-gaming, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      unstable = import nixpkgs-unstable {
        # inherit system;
        config.allowUnfree = true;
      };
      config.allowUnfree = true;
    in
    {
      nixosConfigurations = {
        gnome = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs;};
          modules = [
            ./hosts/gnome/configuration.nix
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
                users.mario = ./home/gnome/mario/home.nix;
              };
            }
          ];
        };

        plasma = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs;};
          modules = [
            ./hosts/plasma/configuration.nix
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
                users.mario = ./home/plasma/mario/home.nix;
              };
            }
          ];
        };
      };
    };
}
