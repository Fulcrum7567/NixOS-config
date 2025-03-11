{ inputs, pkgs-default, stylix-module, ... }:
{
	imports = [
		stylix-module.nixosModules.stylix
	];

	stylix = {
		enable = true;
		autoEnable = true;

		homeManagerIntegration.followSystem = true;
		homeManagerIntegration.autoImport = true;


	};
	stylix.base16Scheme = "${pkgs-default.base16-schemes}/share/themes/nord.yaml";

	boot.plymouth.enable = true;
	
} 
