{
  description = "Nickel's nixos configuration, based on Frost-Phoenix's configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    # antigravity-nix.url = "github:jacopone/antigravity-nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    #nix codoe formater
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";

    # for cashyOS core
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nix-gaming.url = "github:fufexan/nix-gaming";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvim
    nvf.url = "github:NotAShelf/nvf";

    #spicetify-nix = {
    #  url = "github:gerg-l/spicetify-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    hyprmag.url = "github:SIMULATAN/hyprmag";
  };

  outputs = {
    nixpkgs,
    self,
    chaotic,
    sops-nix,
    colmena,
    disko,
    ...
  } @ inputs: let
    username = "cif";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/desktop
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
        ];
        specialArgs = {
          host = "desktop";
          inherit self inputs username;
        };
      };
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
        ];
        specialArgs = {
          host = "laptop";
          inherit self inputs username;
        };
      };
      vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/vm
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
        ];
        specialArgs = {
          host = "vm";
          inherit self inputs username;
        };
      };
    };

    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        nodeSpecialArgs = {
          desktop = {
            host = "desktop";
            inherit self inputs username;
          };
          laptop = {
            host = "laptop";
            inherit self inputs username;
          };
          vm = {
            host = "vm";
            inherit self inputs username;
          };
        };
      };

      desktop = {...}: {
        imports = [
          disko.nixosModules.disko
          ./hosts/desktop
          sops-nix.nixosModules.sops
        ];
        deployment = {
          targetHost = "192.168.1.101"; # change ip
          targetUser = username;
          privilegeEscalationCommand = ["sudo" "-E" "--"];
        };
      };

      laptop = {...}: {
        imports = [
          disko.nixosModules.disko
          ./hosts/laptop
          sops-nix.nixosModules.sops
        ];
        deployment = {
          targetHost = "192.168.1.42";
          targetUser = username;
          privilegeEscalationCommand = ["sudo" "-E" "--"];
        };
      };

      vm = {...}: {
        imports = [
          disko.nixosModules.disko
          ./hosts/vm
          sops-nix.nixosModules.sops
        ];
        deployment = {
          targetHost = "192.168.1.102"; # Replace with actual VM IP
          targetUser = username;
          privilegeEscalationCommand = ["sudo" "-E" "--"];
        };
      };
    };
  };
}
