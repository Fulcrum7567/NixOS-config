{ pkgs-default, ... }:
{
	home.packages = with pkgs-default; [
		cava
		iniparser
	];

	programs.waybar.settings.mainBar = {
		"cava" = {
			framerate = 30;
       		autosens = 1;
       		actions = {
				"on-click-right" = "mode";
			};
		};
	};
} 
