{ config, pkgs, lib, ...}:
{
  boot = {
    loader = {
      # systemd-boot.enable = lib.mkForce false;
      # grub = {
      #   enable = true;
      #   useOSProber = true;
      #   efiSupport = true;
      #   device = "nodev";
      # };
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
    substituters = [
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

# Security configuration "DOAS"
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
    brave
    curl
    ddrescue
    distrobox
    dnsutils
    docker-compose
    git
    neovim-unwrapped
    nodejs_20
    nssmdns
    pciutils
    smartmontools
    unzip
    usbutils
    qemu_kvm
    virt-manager
    wget
    xorg.xinput

    # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in 
    pkgs.buildFHSUserEnv (base // {
      name = "fhs";
      targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config]; 
      profile = "export FHS=1"; 
      runScript = "zsh"; 
      extraOutputsToInstall = ["dev"];
    }))
  ];

  users = {
    users.mario = {
      isNormalUser = true;
      initialHashedPassword = "$6$j12Xl/Yi8ZDidqoK$RLO/M7Mw21WXKF/UUHUUpO4kulNJFYJAnTbkhmG98iOWof1QNnEU5/tIGg4U93D6MwBXUFxlUxh9S6.8KYSPq1";
      extraGroups = [ "wheel" "networkmanager" "adbusers" "audio" "video" "docker" "vboxusers" "kvm" "libvirtd" "qemu-libvirtd"];
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

  # sound.enable = false; # <- Causes issues during pipewire usage
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  networking = {
    hostName = "central8"; # Define your hostname.
    networkmanager.enable = true;
    # useDHCP = false;
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [ 80 443 3306 8090 5000 ];
    };

    interfaces = {
      # enp0s20f0u9u2.useDHCP = true;
      br0.useDHCP = true;
      # br0.ipv4.addresses = [ {
      #   address = "172.20.200.234";
      #   prefixLength = 24;
      # }];
    };

    bridges = {
      "br0" = {
        interfaces = [ "enp0s20f0u9u2" ];
      };
    };
  };

  time.timeZone = "Asia/Jakarta";

  # BLUETOOTH
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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

  services = {
    davfs2.enable = true;

    udisks2.enable = true;

    udev.packages = [
      pkgs.android-udev-rules
    ];

    devmon.enable = true;

    flatpak.enable = true;

    fstrim.enable = true;

    gvfs.enable = true;

    printing =  {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        epson-escpr2
        epson-201401w
        epson_201207w
        foomatic-db
        foomatic-db-ppds
        foomatic-db-ppds-withNonfreeDb
        foo2zjs
        gutenprint
        gutenprintBin
      ];
    };

    system-config-printer = {
      enable = true;
    };

    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    mysql = {
      enable = false;
      package = pkgs.mariadb;
    };
    
    power-profiles-daemon = {
      enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
      openFirewall = true;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.system-config-printer = {
    enable = true;
  };

  programs.adb.enable = true;

  virtualisation = {
   libvirtd = {
     enable = true;
     onShutdown = "suspend";
     onBoot = "ignore";
     qemu = {
       ovmf.enable = true;
       ovmf.packages = [ pkgs.OVMFFull.fd ];
       swtpm.enable = true;
       runAsRoot = false;
     };
   };

    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    docker = {
      enable = true;
      enableOnBoot = false;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    spiceUSBRedirection.enable = true;
  };

  system.autoUpgrade.enable = true;
}
