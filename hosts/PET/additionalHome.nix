{ pkgs-default, ... }:
{
	
	# Syncthing
	services.syncthing = {
		enable = true;
		tray.enable = true;

	};
}
