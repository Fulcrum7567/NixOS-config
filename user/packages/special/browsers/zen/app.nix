{ zen-browser, hostSettings, pkgs, ... }:
{
	home.packages = with pkgs; [
		zen-browser.packages."${hostSettings.system}".default
	];
} 
