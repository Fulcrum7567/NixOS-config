{ ... }:
{
	nixpkgs.config.allowBroken = true;
  	nixpkgs.config.allowInsecure = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
    "electron-25.9.0"
  ];

  home.keyboard = {
    layout = "de";
  };
}
