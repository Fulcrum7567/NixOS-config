{ ... }:
{
	programs.waybar.settings.mainBar = {
		"backlight" = {
			on-scroll-up = "brightnessctl -q set 5%+";
			on-scroll-down = "brightnessctl -q set 5%-";
		};
	};
} 
