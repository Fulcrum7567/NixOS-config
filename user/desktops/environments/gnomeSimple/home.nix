{ lib, browserSettings, terminalSettings, explorerSettings, pkgs-default, userSettings, ... }:

	with lib.hm.gvariant;
{
	imports = [
		../gnomeBase/home.nix
		./extensions.nix
	];
	

	dconf.settings = {

	    "org/gnome/desktop/default-applications/terminal" = {
	    	exec = "kitty";
	    };

		"org/gnome/desktop/interface" = {
			enable-animations = true;
			enable-hot-corners = false;
			show-battery-percentage = true;
			toolkit-accessibility = false;
		};

		"org/gnome/desktop/wm/keybindings" = {
			always-on-top = [ "<Control><Super>t" ];
			begin-move = [];
			begin-resize = [];
			close = [ "<Super>q" ];
			cycle-group = [];
			cycle-group-backward = [];
			cycle-panels = [];
			cycle-panels-backward = [];
			cycle-windows = [];
			cycle-windows-backward = [];
			move-to-monitor-down = [ "<Alt><Super>Down" ];
			move-to-monitor-left = [ "<Alt><Super>Left" ];
			move-to-monitor-right = [ "<Alt><Super>Right" ];
			move-to-monitor-up = [ "<Alt><Super>Up" ];
			move-to-workspace-1 = [ "<Shift><Super>1" ];
			move-to-workspace-2 = [ "<Shift><Super>2" ];
			move-to-workspace-3 = [ "<Shift><Super>3" ];
			move-to-workspace-4 = [ "<Shift><Super>4" ];
			move-to-workspace-left = [ "<Shift><Super>Left" ];
			move-to-workspace-right = [ "<Shift><Super>Right" ];
			show-desktop = [ "<Super>d" ];
			switch-applications = [];
			switch-applications-backward = [];
			switch-input-source = [];
			switch-input-source-backward = [];
			switch-panels = [];
			switch-panels-backward = [];
			switch-to-workspace-1 = [ "<Control><Super>1" ];
			switch-to-workspace-2 = [ "<Control><Super>2" ];
			switch-to-workspace-3 = [ "<Control><Super>3" ];
			switch-to-workspace-4 = [ "<Control><Super>4" ];
			switch-to-workspace-left = [ "<Control><Super>Left" ];
			switch-to-workspace-right = [ "<Control><Super>Right" ];
			switch-windows = [ "<Alt>Tab" ];
			switch-windows-backward = [ "<Shift><Alt>Tab" ];
			toggle-fullscreen = [ "F11" ];
			toggle-maximized = [];
		};

		"org/gnome/desktop/peripherals/touchpad" = {
			send-events = true;
			disable-while-typing = true;
			tap-to-click = true;
			edge-scrolling-enabled = false;
			two-finger-scrolling-enabled = true;
			natural-scroll = true;
		};

		"org/gnome/mutter" = {
			edge-tiling = true;
			dynamic-workspaces = true;
			workspaces-only-on-primary = false;
			experimental-features = [ "scale-monitor-framebuffer" "xwayland-native-scaling" ];
		};

		"org/gtk/gtk4/settings/file-chooser" = {
			show-hidden = true;
			fts-enabled = false;
			migrated-gtk-settings = true;
			search-filter-time-type = "last_modified";
		};

		"org/gnome/nautilus/preferences" = {
			default-folder-viewer = "list-view";
		};

		"org/gnome/settings-daemon/plugins/media-keys" = {
			control-center = [ "<Super>i" ];
			home = [ "<Super>e" ];
	    };

	    "org/gnome/shell" = {
			favorite-apps = [ browserSettings.gnomeAppName terminalSettings.gnomeAppName explorerSettings.gnomeAppName ];
			welcome-dialog-last-shown-version = "99.2";
			remember-mount-password = true;
	    };


	    "org/gnome/Console" = {
			font-scale = 1.4000000000000004;
			last-window-maximised = true;
			last-window-size = mkTuple [ 652 480 ];
	    };

	    "org/gnome/desktop/wm/preferences" = {
	    	focus-new-windows = "smart";
	    	button-layout = "appmenu:minimize,maximize,spacer,close";
	    	resize-with-right-button = true;
	    };

	    "org/gnome/desktop/wm/keybindings" = {
	    	always-on-top = [ "<Control><Super>t" ];
	    };

	    "org/gnome/desktop/interface" = {
	    	accent-color = "slate";
	    };

	    "org/gnome/Console" = {
	    	transparency = true;
	    };
	};

	home.file.".local/share/applications/Proton Hotfix.desktop".text = ''
	    [Desktop Entry]
	    Name=Proton Hotfix
	    Exec=/bin/false
	    Type=Application
	    NoDisplay=true
	'';

	home.file.".local/share/applications/Steam Linux Runtime 3.0 (sniper).desktop".text = ''
		[Desktop Entry]
	    Name=Steam Linux Runtime 3.0 (sniper)
	    Exec=/bin/false
	    Type=Application
	    NoDisplay=true
	'';
} 
