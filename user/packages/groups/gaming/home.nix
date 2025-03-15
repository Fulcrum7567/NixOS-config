{ pkgs-default, ... }:
{
	imports = [
		../../binaries/home/discord.nix
	];

	home.packages = with pkgs-default; [
		mangohud
		protonup
		lutris		
	];

	home.sessionVariables = {
		STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

	};
} 
