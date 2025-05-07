{ pkgs-default, ... }:
{	

	programs.waybar.settings.mainBar = {
		"pulseaudio" = {
			"format" = "{icon}";
		    "format-muted" = "";
		    "format-icons" = {
		        "headphone" = "";
		        "hands-free" = "";
		        "headset" = "";
		        "phone" = "";
		        "phone-muted" = "";
		        "portable" = "";
		        "car" = "";
		        "default" = [ "" "" ""];
		        "default-muted" = "";
		    };
		    tooltip-format = "{desc}: {volume}%";
		};
	};
	
} 
