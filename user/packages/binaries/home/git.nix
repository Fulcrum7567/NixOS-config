{ pkgs, lib, pkgs-stable, pkgs-unstable, userSettings, ... }:
{

	imports = [
	];

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
