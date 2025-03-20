{ pkgs-unstable, userSettings, ... }:
{
	home.packages = with pkgs-unstable; [
		nemo
	];	

	dconf.settings = {
	    "org/nemo/preferences" = {
	    	default-terminal = userSettings.terminal;
	    };

	    "org/nemo/preferences" = {
			show-hidden-files = true;
			default-folder-viewer = "list-view";  # Options: "icon-view", "list-view", "compact-view"
			show-home-icon-on-desktop = true;
			show-trash-icon-on-desktop = true;
			confirm-trash = false;
		};

		"org/nemo/window-state" = {
			start-with-toolbar = true;
			start-with-status-bar = true;
			start-with-sidebar = true;
			sidebar-width = 200;
		};
	};
} 
