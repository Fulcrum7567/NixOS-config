{ pkgs, lib, pkgs-stable, pkgs-unstable, ... }:
{
	imports = [
		../../groups/essentials/home.nix
		../../groups/gaming/home.nix
		../../groups/FH/home.nix
	];
} 
