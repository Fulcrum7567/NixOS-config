{ stylix-module, pkgs-default, lib, ... }:
{
	imports = [
		stylix-module.homeManagerModules.stylix
		./wm/hyprland/animations.nix
		./wm/hyprland/decoration.nix
		./wm/hyprland/general.nix
		./wm/hyprland/miscellaneous.nix
		../../bin/apps/waybar/modules/backlight/backlight1.nix
		../../bin/apps/waybar/modules/bluetooth/bluetooth1.nix
		../../bin/apps/waybar/modules/network/network1.nix
		../../bin/apps/waybar/modules/pulseAudio/pulseAudio1.nix
		../../bin/apps/waybar/modules/cava/cava1.nix
		../../bin/apps/waybar/modules/hyprland/window/window1.nix
		../../bin/apps/waybar/modules/mpris/mpris1.nix


		../../bin/apps/waybar/general/general1.nix

	];

	stylix = {
		enable = true;
		autoEnable = true;	
		image = ./../../bin/wallpapers/mountainRange2.jpg;

		polarity = "dark";

		base16Scheme = "${pkgs-default.base16-schemes}/share/themes/nord.yaml";

		cursor = {
			package = pkgs-default.nordzy-cursor-theme;
			name = "Nordzy-cursors";
			size = 28;
		};

		targets = {
			waybar.enable = false;

		};

		opacity = {
			applications = 1.0;
			terminal = 0.8;
			desktop = 1.0;
			popups = 0.8;
		};

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

			
	};

} 
