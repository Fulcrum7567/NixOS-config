{ pkgs-default, ... }:
{	
	home.packages = with pkgs-default; [
		pavucontrol
	];

	programs.waybar.settings.mainBar = {
	"pulseaudio" = {
		"format" = "{volume}% {icon}";
	    "format-bluetooth" = "{volume}% {icon}";
	    "format-muted" = "";
	    "format-icons" = {
	        "headphone" = "";
	        "hands-free" = "";
	        "headset" = "";
	        "phone" = "";
	        "phone-muted" = "";
	        "portable" = "";
	        "car" = "";
	        "default" = ["" ""];
	        "default-muted" = "";
	    };
	    "scroll-step" = 1;
	    "on-click" = "pavucontrol";
	    "ignored-sinks" = ["Easy Effects Sink"];
	};
	};
	
} 
