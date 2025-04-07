{ pkgs-default, lib, userSettings, config, ... }:
{


	home.packages = with pkgs-default; [
		(discord-canary.override {
      withOpenASAR = false;
      withVencord = true;
    })
	];

  /*

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

  # betterdiscord files

  home.activation.createConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "{ \"midnight (nord)\": true }" > ${config.xdg.configHome}/BetterDiscord/data/canary/themes.json
  '';

  */
} 
