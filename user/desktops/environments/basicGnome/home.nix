{ lib, ... }:
{
	services.xserver.desktopManager.gnome.enable = lib.mkDefault true;
} 
