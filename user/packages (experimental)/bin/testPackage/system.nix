# Import the package via system configuration
{ pkgs-default, ... }:
{
	environment.systemPackages = with pkgs-default; [

	];
} 
