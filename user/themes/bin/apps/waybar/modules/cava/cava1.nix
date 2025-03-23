{ pkgs-default, ... }:
{
	home.packages = with pkgs-default; [
		cava
		iniparser
	];

	programs.waybar.settings.mainBar = {
		"cava" = {
			bars = 12;
	       	sleep_timer = 3;
    	   	hide_on_silence = true;
       		stereo = false;
	       	waves = true;
    	   	bar_delimiter = 0;
    		format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
		};
	};
} 
