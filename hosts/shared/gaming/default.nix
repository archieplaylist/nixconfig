{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    vulkan-tools
    bottles
    gamemode
  ];

  programs.steam = {
    enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport32Bit = true;
      # FIX required to expose LD_LIBRARY_PATH
      setLdLibraryPath = true; 
    };
  };
}