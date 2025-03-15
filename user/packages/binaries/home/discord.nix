{ pkgs-default, lib, ... }:
{
	home.packages = with pkgs-default; [
		discord-canary
		betterdiscordctl
	];


  # Auto install betterdiscord

	systemd.user.services.betterdiscord = {
    Unit = {
      Description = "Auto install betterdiscord";
      After = [ "network.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs-default.betterdiscordctl}/bin/betterdiscordctl -f canary install >> ~/.betterdiscord-install.log 2>&1
      '';
      ExecCondition = "${pkgs-default.bash}/bin/bash -c '[ -z \"$( ${pkgs-default.betterdiscordctl}/bin/betterdiscordctl -f canary status | grep \\\"Discord \\\\\\\"index.js\\\\\\\" injected: yes\\\" )\" ]'";
      StandardOutput = "append:/tmp/betterdiscord.log";
      StandardError = "append:/tmp/betterdiscord.log";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

} 
