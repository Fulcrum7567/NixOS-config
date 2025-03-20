{ userSettings, pkgs, ... }:
let
	powerScript = pkgs.pkgs.writeShellScriptBin "switchPowerState" ''
		current=$(powerprofilesctl get)

		case "$current" in
			power-saver)
				powerprofilesctl set balanced
				;;
			balanced)
				powerprofilesctl set performance
				;;
			performance)
				powerprofilesctl set power-saver
				;;
		esac


	'';

in
{
	wayland.windowManager.hyprland.settings = {
		####################
	    ### KEYBINDINGSS ###
	    ####################
	    # See https://wiki.hyprland.org/Configuring/Keywords/
	    "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
	   
		bind = [
			# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
			"$mainMod, Q, killactive"
			"$mainMod, C, exec, $terminal"
			"$mainMod, M, exit"
			"$mainMod, E, exec, $fileExplorer"
			"$mainMod, V, togglefloating,"
			"$mainMod, R, exec, $menu"

			# Switch workspaces with mainMod + [0-9]
			"$mainMod, 1, workspace, 1"
			"$mainMod, 2, workspace, 2"
			"$mainMod, 3, workspace, 3"
			"$mainMod, 4, workspace, 4"
			"$mainMod, 5, workspace, 5"
			"$mainMod, 6, workspace, 6"
			"$mainMod, 7, workspace, 7"
			"$mainMod, 8, workspace, 8"
			"$mainMod, 9, workspace, 9"
			"$mainMod, 0, workspace, 10"

			# Move active window to a workspace with mainMod + SHIFT + [0-9]
			"$mainMod SHIFT, 1, movetoworkspace, 1"
			"$mainMod SHIFT, 2, movetoworkspace, 2"
			"$mainMod SHIFT, 3, movetoworkspace, 3"
			"$mainMod SHIFT, 4, movetoworkspace, 4"
			"$mainMod SHIFT, 5, movetoworkspace, 5"
			"$mainMod SHIFT, 6, movetoworkspace, 6"
			"$mainMod SHIFT, 7, movetoworkspace, 7"
			"$mainMod SHIFT, 8, movetoworkspace, 8"
			"$mainMod SHIFT, 9, movetoworkspace, 9"
			"$mainMod SHIFT, 0, movetoworkspace, 10"

			"$mainMod Control_L, Right, workspace, e+1"
			"$mainMod Control_L, Left, workspace, e-1"
			"$mainMod Control_L, Up, workspace, emtyn"


			", XF86Launch4, exec, ${powerScript}/bin/switchPowerState"

		];

		bindl = [
			", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
		];

		bindel = [
			" , XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
			" , XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
			" , XF86MonBrightnessDown, exec, brightnessctl set 10%-"
			" , XF86MonBrightnessUp, exec, brightnessctl set 10%+"

		];

		bindm = [
			# Move/resize windows with mainMod + LMB/RMB and dragging
			"$mainMod, mouse:272, movewindow"
			"$mainMod, mouse:273, resizewindow"
		];
	};
	
} 
