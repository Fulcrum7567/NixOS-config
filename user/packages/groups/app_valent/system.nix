{ pkgs-default, lib, pkgs-stable, pkgs-unstable, ... }:
{

	programs.kdeconnect = {
	  	enable = true;
	  	package = pkgs-default.valent;
	};


} 
