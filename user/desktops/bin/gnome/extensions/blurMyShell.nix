{ pkgs-default, ... }:
{

	home.packages = with pkgs-default.gnomeExtensions; [
		blur-my-shell
	];

	dconf.settings = {
		"org/gnome/shell" = {
			enabled-extensions = [
				pkgs-default.gnomeExtensions.blur-my-shell.extensionUuid
			];
		};

		"org/gnome/shell/extensions/blur-my-shell" = {
			hacks-level = 2;
			settings-version = 2;
	    };

	    
	};

}