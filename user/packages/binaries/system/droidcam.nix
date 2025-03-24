{ pkgs-default, lib, pkgs-stable, pkgs-unstable, config, ... }:
{

	imports = [
	];

	environment.systemPackages = with pkgs-default; [
           droidcam
		
	];

        programs.adb.enable = true;

        boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

        boot.kernelModules = ["v4l2loopback"];
} 
