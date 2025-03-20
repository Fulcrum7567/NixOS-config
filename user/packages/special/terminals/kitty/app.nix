{ pkgs, ... }:
{
	home.packages = with pkgs; [
		kitty
#		(kitty.overrideAttrs (oldAttrs: {
#      postInstall = oldAttrs.postInstall or "" + ''
#        substituteInPlace $out/share/applications/kitty.desktop \
#          --replace "Icon=kitty" "Icon=/home/fulcrum/testConfig/user/themes/bin/icons/kitty.png"
#      '';
#    }))
	];

	programs.kitty.enable = true;
	
} 
