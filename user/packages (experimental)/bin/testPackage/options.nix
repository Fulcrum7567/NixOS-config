# Imported by system, define your options for the package

{ lib, ... }:
{
	package.testPackage = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable testPackage";
		};
	};
} 
