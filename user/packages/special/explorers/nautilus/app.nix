{ pkgs-unstable, userSettings, terminalSettings, ... }:
{
	home.packages = with pkgs-unstable; [
		nautilus
	];
} 
