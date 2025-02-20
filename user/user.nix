{ userSettings, ... }:
{
	users.users.${userSettings.userName} = {
    isNormalUser = true;
    description = "${userSettings.displayName}";
    extraGroups = [ "networkmanager" "wheel" ];
    uid = 1000;
    hashedPassword = "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
  };
} 
