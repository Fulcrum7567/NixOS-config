{ userSettings, pkgs, ... }:
{
	programs.noisetorch.enable = true;

	/*
	# Start Noisetorch on startup
	systemd.services.noisetorch = {
		description = "Initialize NoiseTorch on startup";
		after = [ "sound.target" "pipewire.service" "pulseaudio.service" ];
		wants = [ "pipewire.service" "pulseaudio.service" ];
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i";
			Restart = "always";
			RestartSec = 5;  # Give it time before restarting if it fails
			User = userSettings.username;  # Replace with your username
		};
	};
	*/


}