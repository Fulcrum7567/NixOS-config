{ lib, pkgs-default, ... }:
{
 	services.xserver.desktopManager.gnome.enable = lib.mkDefault true;

 	environment.gnome.excludePackages = (with pkgs-default; [
		gnome-tour		# tour
		geary			# email
		epiphany		# browser
		evince			# document viewer
		totem			# video player
		gnome-music		# music player
		yelp			# help
		gnome-maps		# maps
		simple-scan		# scan
		gnome-logs		# logs
		gedit 			# editor
	]);

	services.xserver.desktopManager.xterm.enable = false;
	services.xserver.excludePackages = [ pkgs-default.xterm ];

	documentation.nixos.enable = false;
} 
