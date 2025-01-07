{ lib, ... }:
{
	services.xserver.displayManager.gdm.enable = lib.mkDefault true;
 	services.xserver.desktopManager.gnome.enable = lib.mkDefault true;
} 
