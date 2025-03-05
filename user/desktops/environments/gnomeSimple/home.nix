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
	};
} 
