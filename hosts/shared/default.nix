{ config, pkgs, lib, ...}:
{
  boot = {
    loader = {
      # systemd-boot.enable = lib.mkForce false;
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
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
      '';
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };


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
    appimage-run
    bash
    curl
    dnsutils
    git
    firefox
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

  users = {
    users.mario = {
      isNormalUser = true;
      initialHashedPassword = "$6$j12Xl/Yi8ZDidqoK$RLO/M7Mw21WXKF/UUHUUpO4kulNJFYJAnTbkhmG98iOWof1QNnEU5/tIGg4U93D6MwBXUFxlUxh9S6.8KYSPq1";
      extraGroups = [ "wheel" "networkmanager" "adbusers" "audio" "video" "docker" "vboxusers" "kvm"];
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

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  sound.enable = false; # <- Causes issues during pipewire usage
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # lowLatency = {
    #   enable = true;
    #   # defaults (no need to be set unless modified)
    #   quantum = 64;
    #   rate = 48000;
    # };
  };

  networking = {
    
    hostName = "nixdev"; # Define your hostname.
    networkmanager.enable = true;
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

  services = {
    davfs2.enable = true;

    devmon.enable = true;

    flatpak.enable = true;

    fstrim.enable = true;

    gvfs.enable = true;

    printing =  {
      enable = true;
      drivers = with pkgs; [
        foo2zjs 
      ];
    };

    udisks2.enable = true;

    udev.packages = [
      pkgs.android-udev-rules
    ];

    power-profiles-daemon = {
      enable = true;
    };
  };

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

  # virtualisation = {
    # libvirtd = {
    #   enable = true;
    #   onShutdown = "suspend";
    #   onBoot = "ignore";
    #   qemu = {
    #     package = [ 
            # pkgs.qemu_kvm
            # pkgs.virt-manager
          # ];
    #     ovmf.enable = true;
    #     ovmf.packages = [ pkgs.OVMFFull.fd ];
    #     swtpm.enable = true;
    #     runAsRoot = false;
    #   };
    # };

  #   virtualbox.host = {
  #     enable = true;
  #     enableExtensionPack = true;
  #   };

  #   docker = {
  #     enable = true;
  #     enableOnBoot = false;
  #   };
  #   spiceUSBRedirection.enable = true;
  # };

  system.autoUpgrade.enable = true;
}
