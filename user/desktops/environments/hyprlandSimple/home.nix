{ lib, hyprland, pkgs, browserSettings, terminalSettings, explorerSettings, pkgs-default, currentHost, ... }:

{
	imports = [
		../../bin/hyprland/bindings/bindings1.nix
		../../bin/hyprland/vars/vars1.nix
		../../bin/hyprland/autostart/autostart1.nix
		../../bin/hyprland/inputs/device/device1.nix
		../../bin/hyprland/inputs/gestures/gestures1.nix
		../../bin/hyprland/inputs/input/input1.nix
		../../bin/hyprland/feel/feel1.nix
		../../bin/hyprland/idle/idle1.nix

		../../bin/hyprland/plugins/hypr-cursors.nix
		../../bin/hyprland/plugins/hyprgrass.nix
		../../bin/hyprland/plugins/hyprspace.nix

		../../../../hosts/${currentHost}/additionalConfigs/hyprland/monitor.nix

		../../bin/notifications/mako1.nix

		../../bin/waybar/presets/waybar1.nix

	];

	home.packages = with pkgs-default; [
		rofi-wayland
		waybar
		brightnessctl
	];

	




	
	
	wayland.windowManager.hyprland = {
		enable = true;
		package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
		portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
		
		settings = {
			xwayland.force_zero_scaling = 1;
		};

	};

	
	
} 
