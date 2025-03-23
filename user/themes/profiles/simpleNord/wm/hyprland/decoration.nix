{ ... }:
{
	wayland.windowManager.hyprland.settings = {
		# https://wiki.hyprland.org/Configuring/Variables/#decoration
		decoration = {
			rounding = 10;

			# Change transparency of focused and unfocused windows
			active_opacity = 1.0;
			inactive_opacity = 1.0;


			# https://wiki.hyprland.org/Configuring/Variables/#blur
			blur = {
				enabled = true;
				size = 6;
				passes = 3;
				new_optimizations = "on";
				ignore_opacity = "on";

				vibrancy = 0.1696;
			};
		};
	};
} 
