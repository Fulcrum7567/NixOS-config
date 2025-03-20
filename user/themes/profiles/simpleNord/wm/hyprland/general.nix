{ ... }:
{
	wayland.windowManager.hyprland.settings = {
		#####################
		### LOOK AND FEEL ###
		#####################

		# Refer to https://wiki.hyprland.org/Configuring/Variables/

		# https://wiki.hyprland.org/Configuring/Variables/#general

		general = {
			gaps_in = 5;
			gaps_out = 20;

			border_size = 2;

			# https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
			#"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
			#"col.inactive_border" = "rgba(595959aa)";

			

			# Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
			allow_tearing = false;

			layout = "dwindle";

		};
	};
} 
