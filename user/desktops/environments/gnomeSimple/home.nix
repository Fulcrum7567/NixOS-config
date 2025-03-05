{ lib, ... }:

	with lib.hm.gvariant;
{
	imports = [
		../gnomeBase/home.nix
	];

	dconf.settings = {

		"org/gnome/desktop/interface" = {
			enable-animations = true;
			enable-hot-corners = false;
			show-battery-percentage = true;
			toolkit-accessibility = false;
		};

		"org/gnome/desktop/wm/keybindings" = {
			close = [ "<Super>q" ];
			move-to-workspace-1 = [ "<Shift><Super>1" ];
			move-to-workspace-2 = [ "<Shift><Super>2" ];
			move-to-workspace-3 = [ "<Shift><Super>3" ];
			move-to-workspace-4 = [ "<Shift><Super>4" ];
			switch-applications = [];
			switch-applications-backward = [];
			switch-to-workspace-left = [ "<Control><Super>Left" ];
			switch-to-workspace-right = [ "<Control><Super>Right" ];
			switch-windows = [ "<Alt>Tab" ];
			switch-windows-backward = [ "<Shift><Alt>Tab" ];
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
			favorite-apps = [ "zen.desktop" "org.gnome.Console.desktop" "org.gnome.Nautilus.desktop" ];
			welcome-dialog-last-shown-version = "99.2";
	    };

	    "org/gnome/shell/extensions/alphabetical-app-grid" = {
			folder-order-position = "start";
			sort-folder-contents = true;
	    };

	    "org/gnome/Console" = {
			font-scale = 1.4000000000000004;
			last-window-maximised = true;
			last-window-size = mkTuple [ 652 480 ];
	    };
	};
} 
