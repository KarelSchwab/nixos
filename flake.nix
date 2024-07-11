{
    description = "Flake to build my NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        stylix.url = "github:danth/stylix";
    };

    outputs = { self, nixpkgs, stylix }: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ 
                ./configuration.nix 
                stylix.nixosModules.stylix 
            ];
        };
    };
}
