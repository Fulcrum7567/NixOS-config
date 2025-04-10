{ inputs, config, pkgs-default, pkgs, ... }:
{
	imports = [
		../GLOBAL/hardware/system/bluetooth.nix
	];

	# From https://asus-linux.org/guides/nixos/


	boot.kernelPackages = pkgs.linuxPackages_latest;

	services.supergfxd.enable = true;

	/* BROKEN
	services = {
	    asusd = {
	      enable = true;
	     	enableUserService = true;
	    };
	};
	*/

		
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


	
	# Fixing touchpad
	services.udev.packages = with pkgs; [ libinput ];
  	services.libinput.enable = true;
	boot.kernelModules = [ "hid-multitouch" "i2c-hid" ]; 
 

	# Fixed suspend error
	boot.kernelParams = [
	    "mmc_core.disable_uhs2=1"
	    "mem_sleep_default=deep"
	];   

	/* DISABLED
	services.udev.extraRules = ''
	  ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
	'';
	*/

	



	# Battery charging limit (DISABLED)
	powerManagement.powertop.enable = true;                           # enable powertop auto tuning on startup.

	services.system76-scheduler.settings.cfsProfiles.enable = true;   # Better scheduling for CPU cycles - thanks System76!!!
	services.thermald.enable = true;                                  # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
	services.power-profiles-daemon.enable = true;                    # Disable GNOMEs power management
	services.tlp = {                                                  # Enable TLP (better than gnomes internal power manager)
		enable = false;
		settings = { # sudo tlp-stat or tlp-stat -s or sudo tlp-stat -p
			CPU_BOOST_ON_AC = 1;
			CPU_BOOST_ON_BAT = 0;
			CPU_HWP_DYN_BOOST_ON_AC = 1;
			CPU_HWP_DYN_BOOST_ON_BAT = 0;
			CPU_SCALING_GOVERNOR_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
			CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
			CPU_SCALING_MIN_FREQ_ON_AC = 400000;  # 400 MHz
			CPU_SCALING_MAX_FREQ_ON_AC = 4200000; # 4,2 GHz
			START_CHARGE_THRESH_BAT0 = 75;
			STOP_CHARGE_THRESH_BAT0 = 81;
		};
	};


}
