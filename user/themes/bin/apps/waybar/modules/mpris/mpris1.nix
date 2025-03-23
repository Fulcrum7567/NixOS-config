{ pkgs-default, ... }:
{

	home.packages = with pkgs-default; [
		playerctl
	];

	programs.waybar.settings.mainBar = {
		"mpris" = {
			"format" = "{status_icon} {player}: {title}";
			"player-icons" = {
				"default" = "▶";
				"mpv" = "🎵";
			};
			"status-icons" = {
				"paused" = "⏸";
				playing = "▶";
			};
			title-len = 20;
		};
	};

}