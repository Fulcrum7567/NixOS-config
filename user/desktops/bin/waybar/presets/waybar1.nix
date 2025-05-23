{ pkgs-default, hostSettings, pkgs-stable, ... }:
{

	imports = [
		../modules/backlight/backlight1.nix
		../modules/battery/battery1.nix
		../modules/bluetooth/bluetooth1.nix
		../modules/power-profiles-daemon/ppd1.nix
		../modules/pulseAudio/pulseAudio1.nix
		../modules/cava/cava1.nix
		../modules/hyprland/window/window1.nix
		../modules/mpris/mpris1.nix
		../modules/network/network1.nix
		../modules/privacy/privacy1.nix

	];

	fonts.fontconfig.enable = true;

	home.packages = with pkgs-stable; [
		nerdfonts
		google-fonts
	];


	programs.waybar = {
		enable = true;
		package = pkgs-default.waybar;
		settings = {
			mainBar = {
				height = 27;
				layer = "top";
				modules-left = [ "hyprland/workspaces" "cava" ];
				modules-center = [ "hyprland/window" "clock" "mpris" ];
				modules-right = [ "tray" "backlight" "bluetooth" "network" "pulseaudio" ] ++ (
					if (hostSettings.systemType == "laptop") then
						[ "battery" "power-profiles-daemon" ]
					else
						[]
				);
			};
		};
	};
} 
