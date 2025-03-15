{ pkgs-default, ... }:
{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		gamescopeSession.enable = true;
		extraCompatPackages = [ pkgs-default.proton-ge-bin ];
	};
	programs.gamemode.enable = true;

	environment.systemPackages = with pkgs-default; [
  		steam-run
		libva
		libva-utils
		mesa
		vulkan-tools
	];
	
	environment.variables = {
  		"STEAM_FORCE_WAYLAND" = "1";
	};
} 
