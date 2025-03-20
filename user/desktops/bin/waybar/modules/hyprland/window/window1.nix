{ ... }:
{
	programs.waybar.settings.mainBar = {
		"hyprland/window" = {
		    "format" = "{initialTitle}";
		    "rewrite" = {
		        "(.*) — Mozilla Firefox" = "🌎 $1";
		        "(.*) - fish" = "> [$1]";
		    };
		    "separate-outputs" = true;
		};
	};
} 
