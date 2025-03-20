{ hypr-dynamic-cursors, pkgs, ... }:
{
	wayland.windowManager.hyprland = {
		plugins = [
			hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
		];

		

		settings.plugin.dynamic-cursors = {
			enabled = true;

			mode = "stretch";

			stretch = {
				limit = 1500;
				function = "quadratic";
			};

			shake = {
				enabled = true;
				nearest = true;
			};

			hyprcursor = {
				enabled = true;
				nearest = true;
			};
		};
	};
} 
