{ stylix-module, pkgs-default, lib, ... }:
{
	imports = [
		stylix-module.homeManagerModules.stylix
	];

	stylix = {
		enable = true;
		image = ./../../bin/wallpapers/cpu_city.png;
		polarity = "dark";

		targets = {
			kitty.enable = true;
			gtk.enable = true;
		};
		
		base16Scheme = "${pkgs-default.base16-schemes}/share/themes/nord.yaml";

	};

	programs.kitty.settings = {
		background_opacity = lib.mkForce "0.60";
		modify_font = "cell_width 90%";
	};

} 
