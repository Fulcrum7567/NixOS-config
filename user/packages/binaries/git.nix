{ pkgs, lib, pkgs-stable, pkgs-unstable, ... }:
{

	imports = [
	];

	home.packages = with pkgs; [
        git 
	];
	programs.git.enable = true;
} 