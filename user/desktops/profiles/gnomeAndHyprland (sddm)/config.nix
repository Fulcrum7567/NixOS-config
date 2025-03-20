{ lib, ... }:
{
	imports = [
		../../environments/gnomeSimple/config.nix
		../../environments/hyprlandSimple/system.nix
	];


	services.xserver.displayManager.gdm.enable = lib.mkForce false;
	services.displayManager.sddm.enable = true;
} 
