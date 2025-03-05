{ ... }:
let
	english = "en_GB.UTF-8";
	german = "de_DE.UTF-8";
in
{
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	nixpkgs.config.allowUnfree = true;

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
  
}
