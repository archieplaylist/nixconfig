{ config, pkgs, ...}:
{
  boot = {
    loader = {
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
        # theme = pkgs.fetchFromGitHub
        #   {
        #     owner = "semimqmo";
        #     repo = "sekiro_grub_theme";
        #     rev = "1affe05f7257b72b69404cfc0a60e88aa19f54a6";
        #     sha256 = "02gdihkd2w33qy86vs8g0pfljp919ah9c13cj4bh9fvvzm5zjfn1";
        #   }
        # + "/Sekiro";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    supportedFilesystems = [ 
      "ext4"
      "btrfs"
      "xfs"
      #"zfs"
      "ntfs"
      "fat" "vfat" "exfat"
      "cifs" # mount windows share 
    ];
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Manual optimise storage: nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;


# Security configuration
  security.sudo.enable = false;                      
  security.doas = {
    enable = true;
    extraRules = [ {
      users = [ "mario" ];
      keepEnv = true;
      persist = true;
    } ];
  };

  environment.systemPackages = with pkgs; [
    curl
    dnsutils
    git
    firefox
    libsForQt5.plasma-browser-integration
    neovim-unwrapped
    pciutils
    unzip
    usbutils
    wget
    xorg.xinput

    # devenv.packages."${pkgs.system}".devenv

    # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in 
    pkgs.buildFHSUserEnv (base // {
      name = "fhs";
      targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config]; 
      profile = "export FHS=1"; 
      runScript = "bash"; 
      extraOutputsToInstall = ["dev"];
    }))
  ];

  environment.variables.EDITOR = "nvim";

  users = {
    users.mario = {
      isNormalUser = true;
      initialHashedPassword = "$6$j12Xl/Yi8ZDidqoK$RLO/M7Mw21WXKF/UUHUUpO4kulNJFYJAnTbkhmG98iOWof1QNnEU5/tIGg4U93D6MwBXUFxlUxh9S6.8KYSPq1";
      extraGroups = [ "wheel" "networkmanager" "adbusers" "audio" "video" ];
    };
    defaultUserShell = pkgs.zsh;
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts
      font-awesome
      noto-fonts       
      noto-fonts-cjk    
      noto-fonts-emoji  
      noto-fonts-extra

      (nerdfonts.override { fonts = [ 
        "Iosevka"
        "FiraCode"
        "JetBrainsMono"
        ]; })
    ];
  };

  sound.enable = false; # <- Causes issues during pipewire usage
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    networkmanager.enable = true;
#     wireless.enable = true;
    firewall.enable = true;
    firewall.allowPing = false;
  };
  time.timeZone = "Asia/Jakarta";

  # BLUETOOTH
  # hardware.bluetooth.enable = true;
  # services.blueman.enable = true;


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

  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  services = {
    devmon.enable = true;
    flatpak.enable = true;
    fstrim.enable = true;
    printing.enable = true;
    udisks2.enable = true;
  };

  services.power-profiles-daemon = {
    enable = true;
  };
  security.polkit.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

# Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = true;
    };
    openFirewall = true;
  };

  system.autoUpgrade.enable = true;
}
