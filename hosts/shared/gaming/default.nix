{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # wineWowPackages.stable
    vulkan-tools
#     lutris
#     bottles
#     gamemode
    # yuzu-mainline
  ];

#   programs.steam = {
#     enable = true;
#   };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
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