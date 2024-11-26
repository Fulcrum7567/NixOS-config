{
	description = "Flake of Fulcrum";
  
  
	# ╔══════════════════════════════════════════════════════════════╗
	# ║                                                              ║
	# ║    ooOoOOo o.     O OooOOo.  O       o oOoOOoOOo .oOOOo.     ║
	# ║       O    Oo     o O     `O o       O     o     o     o     ║
	# ║       o    O O    O o      O O       o     o     O.          ║
	# ║       O    O  o   o O     .o o       o     O      `OOoo.     ║
	# ║       o    O   o  O oOooOO'  o       O     o           `O    ║
	# ║       O    o    O O o        O       O     O            o    ║
	# ║       O    o     Oo O        `o     Oo     O     O.    .O    ║
	# ║    ooOOoOo O     `o o'        `OoooO'O     o'     `oooO'     ║
	# ║                                                              ║
	# ╚══════════════════════════════════════════════════════════════╝

	inputs = {
  
		# input nixpkgs
		nixpkgs-stable.url = "nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		
		
		# input home-manager
		home-manager-stable = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		}
		
		home-manager-unstable = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};
	
	};

	outputs = inputs@{ self, ... }:
	let
	
		# currentDeviceFile = import ./devices/currentDevice.nix;
		# currentDevice = "PET";
		# deviceSettings = import (./devices/${currentDevice}/deviceConfig.nix);
		# deviceUserSettings = import (./users/${deviceSettings.user}/deviceSettings/${currentDevice}.nix);
		
		
		# ╔══════════════════════════════╗
		# ║                              ║
		# ║     o                        ║
		# ║    O                         ║
		# ║    o                  O      ║
		# ║    O                 oOo     ║
		# ║    OoOo. .oOo. .oOo   o      ║
		# ║    o   o O   o `Ooo.  O      ║
		# ║    o   O o   O     O  o      ║
		# ║    O   o `OoO' `OoO'  `oO    ║
		# ║                              ║
		# ╚══════════════════════════════╝
		
		# Get name of current host
		currentHost = (import ./hosts/currentHost.nix )
		
		# Get settings of current host
		hostSettings = import (./hosts/${currentHost}/hostSettings.nix);
		
		
		# ╔═══════════════════════════════╗
		# ║                               ║
		# ║          o                    ║
		# ║          O                    ║
		# ║          o                    ║
		# ║          o                    ║
		# ║    .oOo. O  o  .oOoO .oOo     ║
		# ║    O   o OoO   o   O `Ooo.    ║
		# ║    o   O o  O  O   o     O    ║
		# ║    oOoO' O   o `OoOo `OoO'    ║
		# ║    O               O          ║
		# ║    o'           OoO'          ║
		# ║                               ║
		# ╚═══════════════════════════════╝
		
		# define stable pkgs
		pkgs-stable = import inputs.nixpkgs-stable {
			system = hostSettings.system;
			config = {
				allowUnfree = true;
				allowUnfreePredicate = (_: true);
			};
		};
		
		# patch unstable packages
		nixpkgs-patched =
			(import inputs.nixpkgs-unstable { system = hostSettings.system; rocmSupport = (if systemSettings.gpu == "amd" then true else false); }).applyPatches {
			  name = "nixpkgs-patched";
			  src = inputs.nixpkgs-unstable;
			  patches = [ 
						  
						];
			};
			
		# define unstable packages
		pkgs-unstable = import inputs.nixpkgs-patched {
			system = hostSettings.system;
			config = {
			  allowUnfree = true;
			  allowUnfreePredicate = (_: true);
			};
			overlays = [ inputs.rust-overlay.overlays.default ];
		  };
		  
		# define default packages
		pkgs = (if (hostSettings.defaultPackageState == "stable") then 
					pkgs-stable
				else
					pkgs-unstable
				);
				
				
					
		# define lib
		lib = (if (hostSettings.systemState == "stable") then 
					inputs.nixpkgs-stable.lib
				else
					inputs.nixpkgs-unstable.lib
				);
				
				

		# define home-manager
		home-manager = (if (hostSettings.systemState == "stable") then
							inputs.home-manager-stable
						else
							inputs.home-manager-unstable
						);
						
		
		# ╔═════════════════════════════════════════════╗
		# ║                                             ║
		# ║                       O                     ║
		# ║                      oOo                    ║
		# ║    .oOo  O   o .oOo   o   .oOo. `oOOoOO.    ║
		# ║    `Ooo. o   O `Ooo.  O   OooO'  O  o  o    ║
		# ║        O O   o     O  o   O      o  O  O    ║
		# ║    `OoO' `OoOO `OoO'  `oO `OoO'  O  o  o    ║
		# ║              o                              ║
		# ║           OoO'                              ║
		# ║                                             ║
		# ╚═════════════════════════════════════════════╝
		
		# supported systems
		supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

		# Function to generate a set based on supported systems:
		forAllSystems = (if (systemSettings.systemState == "stable") then
							inputs.nixpkgs-stable.lib.genAttrs supportedSystems
						else
							inputs.nixpkgs-unstable.lib.genAttrs supportedSystems
						);

		# Attribute set of nixpkgs for each system:
		nixpkgsFor = (if (systemSettings.systemState == "stable") then
						forAllSystems (system: import inputs.nixpkgs-stable { inherit system; })
					else
						forAllSystems (system: import inputs.nixpkgs-unstable { inherit system; })
					);
    

  in
  {
	
	# ╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
	# ║                                                                                                                                ║
	# ║    .oOOOo.  o       O .oOOOo.  oOoOOoOOo o.OOoOoo Oo      oO                                                                   ║
	# ║    o     o  O       o o     o      o      O       O O    o o                                                                   ║
	# ║    O.       `o     O' O.           o      o       o  o  O  O                                                                   ║
	# ║     `OOoo.    O   o    `OOoo.      O      ooOO    O   Oo   O                                                                   ║
	# ║          `O    `O'          `O     o      O       O        o ooooooooo                                                         ║
	# ║           o     o            o     O      o       o        O                                                                   ║
	# ║    O.    .O     O     O.    .O     O      O       o        O                                                                   ║
	# ║     `oooO'      O      `oooO'      o'    ooOooOoO O        o                                                                   ║
	# ║     .oOOOo.   .oOOOo.  o.     O OOooOoO ooOoOOo  .oOOOo.  O       o `OooOOo.     Oo    oOoOOoOOo ooOoOOo  .oOOOo.  o.     O    ║
	# ║    .O     o  .O     o. Oo     o o          O    .O     o  o       O  o     `o   o  O       o        O    .O     o. Oo     o    ║
	# ║    o         O       o O O    O O          o    o         O       o  O      O  O    o      o        o    O       o O O    O    ║
	# ║    o         o       O O  o   o oOooO      O    O         o       o  o     .O oOooOoOo     O        O    o       O O  o   o    ║
	# ║    o         O       o O   o  O O          o    O   .oOOo o       O  OOooOO'  o      O     o        o    O       o O   o  O    ║
	# ║    O         o       O o    O O o          O    o.      O O       O  o    o   O      o     O        O    o       O o    O O    ║
	# ║    `o     .o `o     O' o     Oo o          O     O.    oO `o     Oo  O     O  o      O     O        O    `o     O' o     Oo    ║
	# ║     `OoooO'   `OoooO'  O     `o O'      ooOOoOo   `OooO'   `OoooO'O  O      o O.     O     o'    ooOOoOo  `OoooO'  O     `o    ║
	# ║                                                                                                                                ║
	# ╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
	
    # ----- SYSTEM CONFIGURATION ----- #
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = hostSettings.system;
        modules = [
          ./devices/${currentDevice}/deviceConfigs/configuration.nix
          ./users/${deviceSettings.user}/systemConfig.nix

        ];
        specialArgs = {
          inherit currentDevice;
          inherit deviceUserSettings;
          inherit lib;
          inherit pkgs;
        };
      };
    };
	
	

    # Expose the system configuration as the default package
    defaultPackage."x86_64-linux" = self.nixosConfigurations.system.config.system.build.toplevel;

    # ----- HOME-MANAGER CONFIGURATION ----- #
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./users/${deviceSettings.user}/homeConfig.nix ];
        extraSpecialArgs = {
          inherit deviceSettings;
          inherit deviceUserSettings;
        };
      };
    };
	
	
	# define packages for installation
	packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ]; # I could make this fancier by adding other deps
            text = ''${./install.sh} "$@"'';
          };
        });
	
	# define apps for installation
	apps = forAllSystems (system: {
        default = self.apps.${system}.install;

        install = {
          type = "app";
          program = "${self.packages.${system}.install}/bin/install";
        };
      });
    };
	
  };
}
