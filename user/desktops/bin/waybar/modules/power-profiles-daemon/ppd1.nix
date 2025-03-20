{ ... }:
{
	programs.waybar.settings.mainBar = {
		"power-profiles-daemon" = {
			"format" = "{icon}";
			"tooltip-format" = "Power profile: {profile}";
			"tooltip" = true;
			"format-icons" = {
				"default"= "";
				"performance"= "";
				"balanced"= "";
				"power-saver"= "";
			};
		};
	};
} 
