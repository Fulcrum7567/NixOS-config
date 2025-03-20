{ pkgs, lib, config, ... }:
let
	startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
		waybar &


	'';
in
{
	wayland.windowManager.hyprland.settings = {
		exec-once = "${startupScript}/bin/start";
	};
} 
