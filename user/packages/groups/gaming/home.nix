{ pkgs-default, ... }:
{
imports = [
   ../../binaries/home/minecraft.nix
   ../../binaries/home/discord.nix

];

	home.packages = with pkgs-default; [
		mangohud
		protonup
		lutris
		heroic
	];

	home.sessionVariables = {
		STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

	};
} 
