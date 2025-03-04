{ lib, ... }:
{
	inputs = [
		../../environments/basicGnome/config.nix
	];


	services.xserver.displayManager.gdm.enable = lib.mkDefault true;
} 
