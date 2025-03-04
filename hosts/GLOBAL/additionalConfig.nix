{ ... }:
{
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nixpkgs.config.allowBroken = true;
  	nixpkgs.config.allowInsecure = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
  
}
