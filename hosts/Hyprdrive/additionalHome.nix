{ pkgs, hostSettings, ... }:
{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Switch audio output";
      command = "bash ${hostSettings.dotfilesDir}/system/scripts/custom/switchAudioOutput.sh";
      binding = "<Control><Alt>KP_Left";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };

  };
}
