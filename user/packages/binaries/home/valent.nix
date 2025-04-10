{ pkgs-default, lib, pkgs-stable, pkgs-unstable, currentHost, ... }:
{

	programs.kdeconnect = {
	  	enable = true;
	  	package = pkgs-default.valent;
	};

	dconf.settings = {
		"ca/andyholmes/valent/" = {
			name = currentHost;
		};
	};

} 
