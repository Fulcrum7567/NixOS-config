{ pkgs-default, ... }:
{

    programs.waybar.settings.mainBar = {
        "privacy" = {
            "icon-spacing" = 4;
            "icon-size" = 18;
            "transition-duration" = 250;
            "modules" = [
                {
                    "type" = "screenshare";
                    "tooltip" = true;
                    "tooltip-icon-size" = 24;
                }
                {
                    "type" = "audio-in";
                    "tooltip" = true;
                    "tooltip-icon-size" = 24;
                }
            ];
        };
    };

}