{ hyprspace, pkgs, ... }:
{
	wayland.windowManager.hyprland = {
		plugins = [
			hyprspace.packages.${pkgs.system}.Hyprspace
		];

		settings.bind = [
			"$mainMod, Tab, overview:toggle"
		];

	};
} 
