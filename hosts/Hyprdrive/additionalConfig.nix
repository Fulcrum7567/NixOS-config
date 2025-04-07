{ config, pkgs, inputs, ... }:
{

   imports = [
      "${inputs.nixos-hardware}/gigabyte/b550/default.nix"
   ];

   
   hardware.graphics.enable = true;

   
   services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
   };


   hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;

      powerManagement.finegrained = false;


      open = true;

      nvidiaSettings = true;


      package = config.boot.kernelPackages.nvidiaPackages.stable;

   };

   boot.kernelPackages = pkgs.linuxPackages_latest;


   # Drives:
   fileSystems."/mnt/SSD-Games" = {
      device = "/dev/nvme0n1p5";
      fsType = "ext4";
      options = [ "defaults" ];
   };

   fileSystems."/mnt/hdd" = {
      device = "/dev/disk/by-uuid/DC0673760673508E";
      fsType = "ntfs-3g";
      options = [ "uid=1000" "gid=1000" "umask=0022" "windows_names" "big_writes" ];
   };
   
   

   security.rtkit.enable = true;
   services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
   };
}
