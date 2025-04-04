{ inputs, config, pkgs-default, pkgs, ... }:
{
	imports = [
		../GLOBAL/hardware/system/bluetooth.nix
	];

	# From https://asus-linux.org/guides/nixos/
	services.supergfxd.enable = true;
	services = {
	    asusd = {
	      enable = true;
	     	enableUserService = true;
	    };
	};

		
	# Enable OpenGL
	hardware.graphics = {
		enable = true;
	};

	# Load nvidia driver for Xorg and Wayland
	services.xserver.videoDrivers = [ "nvidia" ];

	hardware.nvidia = {

		# Modesetting is required.
		modesetting.enable = true;

		# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
		# Enable this if you have graphical corruption issues or application crashes after waking
		# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
		# of just the bare essentials.
		powerManagement.enable = true;

		# Fine-grained power management. Turns off GPU when not in use.
		# Experimental and only works on modern Nvidia GPUs (Turing or newer).
		powerManagement.finegrained = true;

		# Use the NVidia open source kernel module (not to be confused with the
		# independent third-party "nouveau" open source driver).
		# Support is limited to the Turing and later architectures. Full list of 
		# supported GPUs is at: 
		# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
		# Only available from driver 515.43.04+
		open = true;

		# Enable the Nvidia settings menu,
		# accessible via `nvidia-settings`.
		nvidiaSettings = true;

		# Optionally, you may need to select the appropriate driver version for your specific GPU.
		package = config.boot.kernelPackages.nvidiaPackages.stable;

		prime = {
			offload = {
				enable = true;
				enableOffloadCmd = true;
			};
			intelBusId = "PCI:0:2:0";
			nvidiaBusId = "PCI:1:0:0";
		};

		dynamicBoost.enable = false;
	};


	# TODO
	

	services.udev.packages = with pkgs; [ libinput ];


  	services.libinput.enable = true;


	boot.kernelPackages = pkgs.linuxPackages_latest;

	boot.kernelModules = [ "hid-multitouch" "i2c-hid" ];    

	services.udev.extraRules = ''
	  ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
	'';


}
