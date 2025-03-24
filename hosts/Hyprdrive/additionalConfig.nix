{ config, pkgs, ... }:
{
   hardware.graphics.enable = true;
   hardware.opengl = {
      enable = true;
   };

   
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

}
