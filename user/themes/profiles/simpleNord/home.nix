{ stylix-module, pkgs-default, lib, ... }:
{
	imports = [
		stylix-module.homeManagerModules.stylix
	];

	stylix = {
		enable = true;
		autoEnable = true;
		image = ./../../bin/wallpapers/forest1.jpg;

		polarity = "dark";

		base16Scheme = "${pkgs-default.base16-schemes}/share/themes/nord.yaml";

		cursor.package = pkgs-default.nordzy-cursor-theme;
		cursor.name = "Nordzy-cursors";

		fonts = {
			monospace = {
				package = pkgs-default.nerdfonts.override {fonts = ["JetBrainsMono"];};
				name = "JetBrainsMono Nerd Font Mono";
			};

			sansSerif = {
				package = pkgs-default.dejavu_fonts;
				name = "DejaVu Sans";
			};

			serif = {
				package = pkgs-default.dejavu_fonts;
				name = "DejaVu Serif";
			};

			sizes = {
				applications = 12;
				terminal = 15;
				desktop = 10;
				popups = 10;
			};
		};

		opacity = {
			applications = 1.0;
			terminal = 0.8;
			desktop = 1.0;
			popups = 0.8;
		};




		targets = {
			kitty.enable = true;
			gtk.enable = true;
		};
		
	};

	#programs.kitty.settings = {
	#	background_opacity = lib.mkForce "0.80";
	#	modify_font = "cell_width 90%";
	#};

} 
