{ pkgs, lib, pkgs-stable, pkgs-unstable, userSettings, ... }:
{
	

	home.packages = with pkgs; [
        	git
	];
	programs.git = {
		enable = true;
		userName = userSettings.git.userName;
		userEmail = userSettings.git.userEmail;
		extraConfig = {
			credential.helper = "store";
		};
	};
	
} 
