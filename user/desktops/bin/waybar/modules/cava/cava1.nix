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
       		bars = 12;
	       	sleep_timer = 3;
    	   	hide_on_silence = true;
       		stereo = false;
	       	waves = false;
    	   	bar_delimiter = 0;
    		format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
       		actions = {
				"on-click-right" = "mode";
			};
		};
	};
} 
