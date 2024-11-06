In this directory each host is defined.
The format is as followed:

_HOST_NAME_
	configuration.nix	------------ default configuration file, created during installation
	hardware-configuration.nix	---- hardware configuration of this device, created during installation
	additionalHomeConfig.nix	---- additional configuration to be imported for home manager on this device 
	additionalConfig.nix	-------- additional configuration to be imported for this device
