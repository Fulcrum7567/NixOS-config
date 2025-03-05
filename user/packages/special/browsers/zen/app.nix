{ inputs, hostSettings, pkgs, ... }:
{
	home.packages = with pkgs; [
		inputs.zen-browser.packages."${hostSettings.system}".default
	];
} 
