{ ... }:
{
	programs.waybar.settings.mainBar = {
		"backlight" = {
		    "format" = "{icon}";
		    "format-icons" = [ "" "" "" ""];
		    tooltip = true;
		    tooltip-format = "Brightness: {percent}%";
		};
	};
} 
