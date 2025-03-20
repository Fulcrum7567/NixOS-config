{ userSettings, ... }:
{
	wayland.windowManager.hyprland.settings = {
		###################
		### MY PROGRAMS ###
		###################

		# See https://wiki.hyprland.org/Configuring/Keywords/

		# Set programs that you use
		"$terminal" = "${userSettings.terminal}";
		"$fileExplorer" = "${userSettings.explorer}";
		"$menu" = "rofi -show drun -show-icons";
	};	
} 
