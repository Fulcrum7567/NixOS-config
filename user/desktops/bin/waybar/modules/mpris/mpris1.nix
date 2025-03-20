{ ... }:
{
	programs.waybar.settings.mainBar = {
		"mpris" = {
			"format" = "DEFAULT = {player_icon} {dynamic}";
			"format-paused" = "DEFAULT = {status_icon} <i>{dynamic}</i>";
			"player-icons" = {
				"default" = "▶";
				"mpv" = "🎵";
			};
			"status-icons" = {
				"paused" = "⏸";
			};
		};
	};

}