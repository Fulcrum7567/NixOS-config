{ pkgs-unstable, ... }:
{
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1w"
              ];

	imports = [
	];

	home.packages = with pkgs-unstable; [
        	sublime4
	];

	
} 
