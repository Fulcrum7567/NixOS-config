{ hyprgrass, pkgs, ... }:
{
	wayland.windowManager.hyprland = {
		plugins = [
			hyprgrass.packages.${pkgs.system}.default
		];

	};
} 
