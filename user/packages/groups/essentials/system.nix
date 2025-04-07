{ pkgs-default, lib, pkgs-stable, pkgs-unstable, ... }:
{

	imports = [
		../../binaries/system/home-manager.nix
		../../binaries/system/droidcam.nix
		../../binaries/system/kdeconnect.nix
		# define on what group this group is based on
	];

	environment.systemPackages = with pkgs-default; [
		# packages that use the default package state
		

	] ++ (with pkgs-stable; [
		# packages that always use the stable branch


	]) ++ (with pkgs-unstable; [
		# packages that always use the unstable branch


	]);
} 
