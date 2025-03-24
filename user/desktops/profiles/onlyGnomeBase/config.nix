{ lib, ... }:
{
	imports = [
		../../environments/gnomeBase/config.nix
	];


	services.xserver.displayManager.gdm.enable = lib.mkDefault true;
} 
