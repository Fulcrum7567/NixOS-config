{ lib, pkgs-default, ... }:

	with lib.hm.gvariant;
{
	dconf.settings = {

		"org/gnome/desktop/input-sources" = {
      		sources = [ (mkTuple [ "xkb" "de" ]) ];
      		xkb-options = [ "terminate:ctrl_alt_bksp" ];
    	};
    };
	
} 
