{ lib, ... }:
{
	imports = [
		../../environments/gnomeSimple/config.nix
	];


	services.xserver.displayManager.gdm.enable = lib.mkDefault true;
} 
