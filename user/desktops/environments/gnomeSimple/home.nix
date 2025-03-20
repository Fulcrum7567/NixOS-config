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

		"42096a05-427c-4a06-b853-382c22ebc1be" = {
	      apps = [ "Counter-Strike 2.desktop" "discord-canary.desktop" "net.lutris.Lutris.desktop" "Split Fiction.desktop" "steam.desktop" ];
	      name = "Games";
	    };

	    "6335ebd3-dcf3-471f-9987-fbce3d8b6c73" = {
	      apps = [ "blueman-manager.desktop" "ca.desrt.dconf-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Extensions.desktop" "org.gnome.FileRoller.desktop" "nvidia-settings.desktop" "rog-control-center.desktop" "org.gnome.Settings.desktop" "org.gnome.SystemMonitor.desktop" ];
	      name = "System";
	      translate = false;
	    };

	    "e915df37-8928-4a1c-91cb-91c1d22a815c" = {
	      apps = [ "org.gnome.Calculator.desktop" "org.gnome.Calendar.desktop" "org.gnome.Snapshot.desktop" "org.gnome.Characters.desktop" "org.gnome.clocks.desktop" "org.gnome.Connections.desktop" "org.gnome.Console.desktop" "org.gnome.Contacts.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "sublime_text.desktop" "org.gnome.TextEditor.desktop" "org.gnome.Weather.desktop" ];
	      name = "Tools";
	      translate = false;
	    };

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
