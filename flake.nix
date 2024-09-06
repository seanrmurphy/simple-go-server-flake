# this was taken from hydra
{
  description = "A simple flake comprising a package and a module which can be added to a NixOS configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11-small";

  outputs =
    {
      self,
      nixpkgs,
      nix,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;

      overlayList = [ self.overlays.default ];

      pkgsBySystem = forEachSystem (
        system:
        import nixpkgs {
          inherit system;
          overlays = overlayList;
        }
      );

    in
    rec {

      # A Nixpkgs overlay that provides a 'simple-go-webserver' package.
      overlays.default = final: prev: { simple-go-server = final.callPackage ./package.nix { }; };

      packages = forEachSystem (system: {
        simple-go-server = pkgsBySystem.${system}.simple-go-server;
        default = pkgsBySystem.${system}.simple-go-server;
      });

      nixosModules = import ./nixos-modules { overlays = overlayList; };

    };
}
