{ pkgs-default, ... }:
{	
	home.packages = with pkgs-default; [
		pavucontrol
	];

	programs.waybar.settings.mainBar = {
	"pulseaudio" = {
		
	    "scroll-step" = 1;
	    "on-click" = "pavucontrol";
	    "ignored-sinks" = ["Easy Effects Sink"];
	};
	};
	
} 
