{ lib, pkgs-default, ... }:
{
	home.packages = with pkgs-default.gnomeExtensions; [
		blur-my-shell
		alphabetical-app-grid
		clipboard-indicator
		dash-to-dock
		just-perfection
		middle-click-to-close-in-overview
		grand-theft-focus
		window-title-is-back
		appindicator
	];

	dconf.settings = {
		"org/gnome/shell" = {
			disable-user-extensions = false;
			enabled-extensions = [
				pkgs-default.gnomeExtensions.blur-my-shell.extensionUuid
				"AlphabeticalAppGrid@stuarthayhurst"
				"clipboard-indicator@tudmotu.com"
				"dash-to-dock@micxgx.gmail.com"
				#"just-perfection-desktop@just-perfection"   # BROKEN!!!
				"middleclickclose@paolo.tranquilli.gmail.com"
				"grand-theft-focus@zalckos.github.com"
				"window-title-is-back@fthx"
				"appindicatorsupport@rgcjonas.gmail.com"
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
	      click-action = "minimize";
	      custom-background-color = true;
	      custom-theme-customize-running-dots = false;
	      customize-alphas = true;
	      dash-max-icon-size = 48;
	      dock-position = "BOTTOM";
	      height-fraction = 0.9;
	      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
	      isolate-workspaces = true;
	      max-alpha = 0.7;
	      middle-click-action = "quit";
	      multi-monitor = true;
	      preview-size-scale = 0.0;
	      running-indicator-style = "DOTS";
	      scroll-action = "cycle-windows";
	      shift-click-action = "launch";
	      shift-middle-click-action = "launch";
	      shortcut = [];
	      shortcut-text = "";
	      show-apps-at-top = false;
	      show-mounts = false;
	      show-show-apps-button = true;
	      show-trash = false;
	      transparency-mode = "DYNAMIC";
	      blur = true;
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
