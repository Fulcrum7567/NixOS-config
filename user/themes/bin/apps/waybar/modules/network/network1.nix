{ pkgs-default, ... }:
{

	programs.waybar.settings.mainBar = {
		"network" = {
		    "format" = "";
		    "format-wifi" = "";
		    "format-ethernet" = "";
		    "format-disconnected" = ""; 
		    "tooltip-format" = "Connected with {essid}\nStrength: {signalStrength}%\nRate: {bandwidthDownBits}";
		    "tooltip-format-disconnected" = "No connection";
		    "max-length" = 50;
		};
	};

}