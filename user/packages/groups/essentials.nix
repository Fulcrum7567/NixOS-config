{ pkgs-default, lib, pkgs-stable, pkgs-unstable, ... }:
{

	imports = [
		# define on what group this group is based on
	];

	home.packages = (with pkgs-default; [
		# packages that use the default package state
		gum


	]) ++ (with pkgs-stable; [
		# packages that always use the stable branch


	]) ++ (with pkgs-unstable; [
		# packages that always use the unstable branch


	]);
} 
