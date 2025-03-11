{ pkgs-default, ... }:
{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		gamescopeSession.enable = true;
		extraCompatPackages = [ pkgs-default.proton-ge-bin ];
	};
	programs.gamemode.enable = true;
} 
