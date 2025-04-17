{ pkgs, hostSettings, userSettings, ... }:
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

    # Syncthing
    services.syncthing = {
        enable = true;
        tray.enable = true;
        user = userSettings.username;

        settings = {
            devices = {
                "PET" = {
                    id = "Q6KKQFG-6H25U33-4BWI7UR-SLD5W5G-VNDOHT5-Q6SU4RF-D5UMGUL-KTTFNQ7";
                };
            };
            folders = {
                "Obsidian" = {
                    path = "/home/${userSettings.username}/Documents/Obsidian";
                    devices = [ "PET" ];
                };
            };
            gui = {
                user = userSettings.username;
                password = "syncthing"; # todo
            };
        };

    };

}
