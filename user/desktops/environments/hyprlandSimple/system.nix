{ inputs, pkgs, hyprland, pkgs-stable,  ... }:
{
	imports = [

	];

	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";

	};

	programs.hyprland = {
		enable = true;
		package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    	portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
	};



} 
