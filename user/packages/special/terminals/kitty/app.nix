{ pkgs, hostSettings, ... }:
let
	customKitty = pkgs.kitty.overrideAttrs (oldAttrs: {
	    postInstall = oldAttrs.postInstall or "" + ''
	      substituteInPlace $out/share/applications/kitty.desktop \
	        --replace "Icon=kitty" "Icon=${hostSettings.dotfilesDir}/user/themes/bin/icons/kitty.png"
	    '';
	});
in
{
	programs.kitty = {
		enable = true;
		package = customKitty;
	};
	
} 
