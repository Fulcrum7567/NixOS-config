{ pkgs-unstable, userSettings, terminalSettings, ... }:
{
	home.packages = with pkgs-unstable; [
		nemo
	];

	home.file.".local/share/nemo/actions/open-in-${userSettings.terminal}.nemo_action".text = ''
	    [Nemo Action]

	    Name=Open in ${userSettings.terminal}
	    Comment=Open the '${userSettings.terminal}' terminal in the selected folder
	    Exec=${terminalSettings.launchAtPath} %F
	    Icon-Name=${userSettings.terminal}
	    Selection=any
	    Extensions=dir;
	    EscapeSpaces=true
	'';

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
