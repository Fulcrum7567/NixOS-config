{ pkgs-default, ... }:
{

	home.packages = with pkgs-default; [
		playerctl
	];

	programs.waybar.settings.mainBar = {
		"mpris" = {
		};
	};

}