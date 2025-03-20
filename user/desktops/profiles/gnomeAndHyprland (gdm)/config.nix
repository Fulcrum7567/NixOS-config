{ lib, ... }:
{
	imports = [
		../../environments/gnomeSimple/config.nix
		../../environments/hyprlandSimple/system.nix
	];


	services.xserver.displayManager.gdm.enable = lib.mkDefault true;
} 
