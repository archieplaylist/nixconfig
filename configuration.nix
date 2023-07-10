{ config, pkgs, ... }:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
  # sudo nix-channel --update nixpkgs-unstable
  unstable = import <nixos-unstable> { config.allowUnfree = true; };

in {
  imports = [ ./hardware-configuration.nix ];

  # sudo dd if=/dev/zero of=/var/lib/swapfile bs=1M count=4k status=progress
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 4*1024;
  } ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  #boot.loader.grub.useOSProber = true;

  networking.hostName = "nixosvm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "id_ID.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "id_ID.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "id_ID.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME
  #  services.xserver.displayManager.gdm.enable = true;
  #  services.xserver.desktopManager.gnome.enable = true;

  # XFCE 
  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xterm.enable = false;
  #     xfce.enable = true;
  #   };
  #   displayManager.defaultSession = "xfce";
  # };

  # KDE PLASMA
  services.xserver = {
    desktopManager = { plasma5.enable = true; };
    displayManager = { sddm.enable = true; };
    displayManager.defaultSession = "plasmawayland";
  };
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [ oxygen ];
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.xserver.videoDrivers = [ "qcl" ];

  hardware.opengl.driSupport32Bit = true;

  # hardware.opengl.extraPackages = [ rocm-opencl-icd ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mario = {
    isNormalUser = true;
    description = "mario";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [
      unstable.firefox
      unstable.brave
      unstable.vscode
      unstable.onlyoffice-bin
      unstable.microsoft-edge
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gparted
    htop
    neofetch
    nixfmt
    vim
    wget
    zsh
    # VM
    # unstable.spice-vdagent # virt manager guest
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      corefonts
    ];
  };

  # fonts.fontDir.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # settings.PermitRootLogin = no;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
