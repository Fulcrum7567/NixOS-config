{ ... }:
{
	programs.waybar.settings.mainBar = {
		"bluetooth" = {
			"format" = "";
			"format-connected" = " ({num_connections})";
			format-off = ""; # Hide when Buetooth disabled
			"tooltip-format-connected-battery" = "Connected: {device_alias}\t({device_battery_percentage}% )";
			"tooltip-format-connected" = "Connected: {device_alias}";
			"tooltip-format-enumerate-connected" = "{num_connections} Connected:\n{device_alias}";
			"tooltip-format-enumerate-connected-battery" = "{num_connections} Connected:\n{device_alias}\t({device_battery_percentage}% ) ";
			"tooltip-format-on" = "Bluetooth active, no connections";
			
		};
	};
} 
