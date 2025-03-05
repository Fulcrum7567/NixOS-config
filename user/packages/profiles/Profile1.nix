{ pkgs, lib, pkgs-stable, pkgs-unstable, ... }:
{
	imports = [
		../groups/essentials.nix
		../binaries/git.nix
	];
} 
