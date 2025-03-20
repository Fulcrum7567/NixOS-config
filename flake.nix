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
		};
		
		home-manager-unstable = {
				url = "github:nix-community/home-manager/master";
				inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		stylix-stable = {
			url = "github:danth/stylix/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};

		stylix-unstable = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};


		nixos-hardware.url = "github:NixOS/nixos-hardware/master";



		hyprland-stable = {
	      	url = "github:hyprwm/Hyprland";
	      	inputs.nixpkgs.follows = "nixpkgs-stable";
	    };

	    hyprland-unstable = {
	      	url = "github:hyprwm/Hyprland";
	      	inputs.nixpkgs.follows = "nixpkgs-unstable";
	    };


	    hyprland-plugins-stable = {
	    	url = "github:hyprwm/hyprland-plugins";
	    	inputs.hyprland.follows = "hyprland-stable";
	    };

	    hyprland-plugins-unstable = {
	    	url = "github:hyprwm/hyprland-plugins";
	    	inputs.hyprland.follows = "hyprland-unstable";
	    };


	    hyprgrass-stable = {
	    	url = "github:horriblename/hyprgrass";
	    	inputs.hyprland.follows = "hyprland-stable";
	    };

	    hyprgrass-unstable = {
	    	url = "github:horriblename/hyprgrass";
	    	inputs.hyprland.follows = "hyprland-unstable";
	    };

	    hyprspace-stable = {
	    	url = "github:KZDKM/Hyprspace";
			inputs.hyprland.follows = "hyprland-stable";
	    };

	    hyprspace-unstable = {
	    	url = "github:KZDKM/Hyprspace";
			inputs.hyprland.follows = "hyprland-unstable";
	    };

	    hypr-dynamic-cursors-stable = {
	        url = "github:VirtCode/hypr-dynamic-cursors";
	        inputs.hyprland.follows = "hyprland-stable"; # to make sure that the plugin is built for the correct version of hyprland
	    };

	    hypr-dynamic-cursors-unstable = {
	        url = "github:VirtCode/hypr-dynamic-cursors";
	        inputs.hyprland.follows = "hyprland-unstable"; # to make sure that the plugin is built for the correct version of hyprland
	    };


		# ╔════════════════════════════════╗
		# ║                                ║
		# ║                                ║
		# ║                                ║
		# ║    .oOoO' .oOo. .oOo. .oOo     ║
		# ║    O   o  O   o O   o `Ooo.    ║
		# ║    o   O  o   O o   O     O    ║
		# ║    `OoO'o oOoO' oOoO' `OoO'    ║
		# ║           O     O              ║
		# ║           o'    o'             ║
		# ║                                ║
		# ╚════════════════════════════════╝


		zen-browser.url = "github:0xc000022070/zen-browser-flake";




	};

	outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager-stable, home-manager-unstable, nixos-hardware, stylix-stable, stylix-unstable, hyprland-stable, hyprland-unstable, hyprland-plugins-stable, hyprland-plugins-unstable, hyprgrass-stable, hyprgrass-unstable, hyprspace-stable, hyprspace-unstable, hypr-dynamic-cursors-stable, hypr-dynamic-cursors-unstable, ... }:
	let

		# ╔═══════════════════════════════════════════════════════════╗
		# ║                                                           ║
		# ║                                    o     o                ║
		# ║                         o         O     O                 ║
		# ║                                   O     o                 ║
		# ║                                   o     O                 ║
		# ║    `o   O .oOoO' `OoOo. O  .oOoO' OoOo. o  .oOo. .oOo     ║
		# ║     O   o O   o   o     o  O   o  O   o O  OooO' `Ooo.    ║
		# ║     o  O  o   O   O     O  o   O  o   O o  O         O    ║
		# ║     `o'   `OoO'o  o     o' `OoO'o `OoO' Oo `OoO' `OoO'    ║
		# ║                                                           ║
		# ╚═══════════════════════════════════════════════════════════╝

		# Get name of current host
		currentHost = (import ./hosts/currentHost.nix ).currentHost;
		
		# Get settings of current host
		hostSettings = ( import ./hosts/${currentHost}/hostSettings.nix );

		# Get user settings
		userSettings = ( import ./user/userSettings.nix );

		browserSettings = ( import ./user/packages/special/browsers/${userSettings.browser}/settings.nix);

		terminalSettings = (import ./user/packages/special/terminals/${userSettings.terminal}/settings.nix);

		editorSettings = (import ./user/packages/special/editors/${userSettings.editor}/settings.nix);

		explorerSettings = (import ./user/packages/special/explorers/${userSettings.explorer}/settings.nix);
		


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

		pkgs-stable = import inputs.nixpkgs-stable {
			system = hostSettings.system;
			config = {
			  	allowUnfree = true;
			  	allowUnfreePredicate = (_: true);
			  	allowInsecure = true;
			  	permittedInsecurePackages = [ "openssl-1.1.1w" ];
			};
		};

		pkgs-unstable = import inputs.nixpkgs-unstable {
			system = hostSettings.system;
			config = {
			  	allowUnfree = true;
			  	allowUnfreePredicate = (_: true);
			  	allowInsecure = true;
			  	permittedInsecurePackages = [ "openssl-1.1.1w" ];
			};
		};

		pkgs-default = (if (hostSettings.defaultPackageState == "stable")
						then
							pkgs-stable
						else
							pkgs-unstable
						);

		pkgs-system = (if (hostSettings.systemState == "stable")
						then
							pkgs-stable
						else
							pkgs-unstable
						);



		lib = (if (hostSettings.systemState == "stable")
				then
					nixpkgs-stable.lib
				else
					nixpkgs-unstable.lib
				);

		home-manager = (if (hostSettings.systemState == "stable")
						then
							home-manager-stable
						else
							home-manager-unstable
						);

		stylix-module = (if (hostSettings.systemState == "stable")
					then
						stylix-stable
					else
						stylix-unstable
				);

		hyprland = (if (hostSettings.systemState == "stable")
					then
						hyprland-stable
					else
						hyprland-unstable
			);

		hyprland-plugins = (if (hostSettings.systemState == "stable")
					then
						hyprland-plugins-stable
					else
						hyprland-plugins-unstable
			);

		hyprgrass = (if (hostSettings.systemState == "stable")
					then
						hyprgrass-stable
					else
						hyprgrass-unstable
			);

		hyprspace = (if (hostSettings.systemState == "stable")
					then
						hyprspace-stable
					else
						hyprspace-unstable
			);

		hypr-dynamic-cursors = (if (hostSettings.systemState == "stable")
					then
						hypr-dynamic-cursors-stable
					else
						hypr-dynamic-cursors-unstable
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
		

		nixosConfigurations = {
			system = lib.nixosSystem {
				system = hostSettings.system;
				modules = [
					./hosts/GLOBAL/additionalConfig.nix
					./hosts/${currentHost}/additionalConfig.nix
					./hosts/${currentHost}/hostConfigs/configuration.nix

					./user/desktops/profiles/${hostSettings.desktop}/config.nix
					./user/themes/profiles/${hostSettings.theme}/config.nix
					./user/packages/profiles/${hostSettings.packageProfile}/system.nix
					./user/packages/special/shell/system.nix

					./user/user.nix

					./system/scripts/wrapper/hive.nix


				];
				specialArgs = {
					inherit pkgs-default pkgs-stable pkgs-unstable inputs stylix-module currentHost hyprland;
				};
			};
		};

		homeConfigurations = {
			user = home-manager.lib.homeManagerConfiguration {
				pkgs = pkgs-system;
				modules = [
					./hosts/GLOBAL/additionalHome.nix
					./hosts/${currentHost}/additionalHome.nix

					./user/desktops/profiles/${hostSettings.desktop}/home.nix
					./user/themes/profiles/${hostSettings.theme}/home.nix

					./user/packages/special/editors/${userSettings.editor}/app.nix
					./user/packages/special/terminals/${userSettings.terminal}/app.nix
					./user/packages/special/browsers/${userSettings.browser}/app.nix
					./user/packages/special/explorers/${userSettings.explorer}/app.nix
					./user/packages/special/shell/home.nix

					./user/packages/profiles/${hostSettings.packageProfile}/home.nix

					./user/home.nix
					./user/var.nix
				];

				extraSpecialArgs = {
					inherit currentHost pkgs-default pkgs-stable pkgs-unstable inputs hostSettings userSettings stylix-module browserSettings editorSettings terminalSettings explorerSettings hyprland hyprland-plugins hyprgrass hyprspace hypr-dynamic-cursors;
				};
			};
		};

	};

}