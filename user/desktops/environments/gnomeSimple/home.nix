{ lib, browserSettings, terminalSettings, pkgs-default, ... }:

	with lib.hm.gvariant;
{
	imports = [
		../gnomeBase/home.nix
	];


	home.packages = with pkgs-default.gnomeExtensions; [
						blur-my-shell
						alphabetical-app-grid
						clipboard-indicator
						dash-to-dock
						just-perfection
						middle-click-to-close-in-overview
						tray-icons-reloaded
						grand-theft-focus
						window-title-is-back
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
			favorite-apps = [ browserSettings.gnomeAppName terminalSettings.gnomeAppName "org.gnome.Nautilus.desktop" ];
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

	    "org/gnome/Console" = {
	    	transparency = true;
	    };

	    # ╔═════════════════════════════════════════════════════════════════════╗
		# ║                                                                     ║
		# ║    o.OOoOoo                                                         ║
		# ║     O                                      o                        ║
		# ║     o               O                                               ║
		# ║     ooOO           oOo                                              ║
		# ║     O       o   O   o   .oOo. 'OoOo. .oOo  O  .oOo. 'OoOo. .oOo     ║
		# ║     o        OoO    O   OooO'  o   O `Ooo. o  O   o  o   O `Ooo.    ║
		# ║     O        o o    o   O      O   o     O O  o   O  O   o     O    ║
		# ║    ooOooOoO O   O   `oO `OoO'  o   O `OoO' o' `OoO'  o   O `OoO'    ║
		# ║                                                                     ║
		# ╚═════════════════════════════════════════════════════════════════════╝

		"org/gnome/shell" = {
			disable-user-extensions = false;
			enabled-extensions = [
				pkgs-default.gnomeExtensions.blur-my-shell.extensionUuid
				"AlphabeticalAppGrid@stuarthayhurst"
				"clipboard-indicator@tudmotu.com"
				"dash-to-dock@micxgx.gmail.com"
				"just-perfection-desktop@just-perfection"
				"middleclickclose@paolo.tranquilli.gmail.com"
				"trayIconsReloaded@selfmade.pl"
				"grand-theft-focus@zalckos.github.com"
				"window-title-is-back@fthx"
			];
		};


		# blur my shell

	    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
	      brightness = 0.6;
	      sigma = 30;
	    };

	    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
	      pipeline = "pipeline_default";
	    };

	    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
	      blur = true;
	      brightness = 0.6;
	      pipeline = "pipeline_default_rounded";
	      sigma = 30;
	      static-blur = true;
	      style-dash-to-dock = 0;
	    };

	    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
	      pipeline = "pipeline_default";
	    };

	    "org/gnome/shell/extensions/blur-my-shell/overview" = {
	      pipeline = "pipeline_default";
	    };

	    "org/gnome/shell/extensions/blur-my-shell/panel" = {
	      brightness = 0.6;
	      pipeline = "pipeline_default";
	      sigma = 30;
	    };

	    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
	      pipeline = "pipeline_default";
	    };

	    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
	      brightness = 0.6;
	      sigma = 30;
	    };


	    # Alphabetical app grid

	    "org/gnome/shell/extensions/alphabetical-app-grid" = {
	      folder-order-position = "start";
	      sort-folder-contents = true;
	    };


	    # Clipboard indicator

	    "org/gnome/shell/extensions/clipboard-indicator" = {
	      disable-down-arrow = true;
	      history-size = 30;
	      keep-selected-on-clear = true;
	      display-mode = 0;
	      paste-button = false;
	      move-item-first = true;
	      preview-size = 32;
	      strip-text = true;
	      toggle-menu = [ "<Super>v" ];
	    };


	    # Dash to dock

	    "org/gnome/shell/extensions/dash-to-dock" = {
	      apply-custom-theme = false;
	      background-color = "rgb(36,31,49)";
	      background-opacity = 0.8;
	      custom-background-color = true;
	      customize-alphas = true;
	      dash-max-icon-size = 48;
	      dock-position = "BOTTOM";
	      height-fraction = 0.9;
	      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
	      max-alpha = 0.7;
	      middle-click-action = "quit";
	      preferred-monitor = -2;
	      preferred-monitor-by-connector = "eDP-1";
	      preview-size-scale = 0.0;
	      running-indicator-style = "DEFAULT";
	      scroll-action = "cycle-windows";
	      shift-click-action = "launch";
	      shift-middle-click-action = "launch";
	      show-show-apps-button = false;
	      show-trash = false;
	      transparency-mode = "DYNAMIC";
	    };


	    # Just perfection

		"org/gnome/shell/extensions/just-perfection" = {
	      accent-color-icon = false;
	      activities-button = true;
	      animation = 4;
	      clock-menu = true;
	      keyboard-layout = false;
	      max-displayed-search-results = 10;
	      notification-banner-position = 2;
	      panel = true;
	      power-icon = true;
	      quick-settings = true;
	      quick-settings-dark-mode = false;
	      quick-settings-night-light = false;
	      search = true;
	      show-apps-button = false;
	      support-notifier-showed-version = 34;
	      world-clock = false;
	    };


	    # middle click close

	    "org/gnome/shell/extensions/middleclickclose" = {
			close-button = "middle";
			keyboard-close = true;
			rearrange-delay = 100;
	    };


	    # Window title is back
	    
	    "org/gnome/shell/extensions/window-title-is-back" = {
	    	colored-icon = false;
			fixed-width = false;
			show-icon = false;
			show-title = false;
	    };
	};
} 
