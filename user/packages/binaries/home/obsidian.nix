{ pkgs-default, ... }:
{
	home.packages = with pkgs-default; [
		obsidian
	];
} 
