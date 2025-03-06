{ pkgs-default, ... }:
{
	home.packages = with pkgs-default; [
		kitty
	];

	programs.kitty.enable = true;
	
} 
