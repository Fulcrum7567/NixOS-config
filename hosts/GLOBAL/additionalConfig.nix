{ currentHost, pkgs, ... }:
let
	english = "en_GB.UTF-8";
	german = "de_DE.UTF-8";
in
{

	imports = [
		./hardware/system/bluetooth.nix
	];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	nixpkgs.config.allowUnfree = true;

	networking.hostName = currentHost;

	time.timeZone = "Europe/Berlin";
	i18n.defaultLocale = english;
	i18n.extraLocaleSettings = {
		LC_NUMERIC = english;

		LC_ADDRESS = german;
		LC_IDENTIFICATION = german;
		LC_MEASSUREMENT = german;
		LC_MONETARY = german;
		LC_NAME = german;
		LC_PAPER = german;
		LC_TELEPHONE = german;
		LC_TIME = german;
	};

	services.xserver = {
		enable = true;
  		xkb.layout = "de";
    	xkb.variant = "";
  	};
	console.keyMap = "de";

	environment.variables = {
		SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = 0;
	};


  	# Set resolution for systemd-boot
	boot.loader.systemd-boot.consoleMode = "max";

	# Garbage collection
	nix.gc = {
		automatic = true;
		dates = "daily";
		options = "--delete-older-than 14d --keep-generations 10";
	};
  
	# Enable ssh
	services.openssh.enable = true;

}
