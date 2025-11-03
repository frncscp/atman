# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config,  pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.timeout = 7;
  boot.loader.grub.default = 2;

  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_lts;

  systemd.user.extraConfig = "DefaultTimeoutStopSec=10s";
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";


  networking.hostName = "atman"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable OPENGL
  hardware.graphics = {
   enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

  modesetting.enable = true;
  open = true;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;  

  };

  system.userActivationScripts.zshrc = "touch .zshrc";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.dhcpcd.enable = false;
  #networking.interfaces.enp5s0.useDHCP = true;

  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  #services.xserver.desktopManager.gnome.enable = true;
  # Enable the COSMIC login manager
  services.displayManager.ly.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

    programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  security.pam.services.swaylock = {};


  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "intl";
  #};


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.franc = {
    isNormalUser = true;
    description = "franc";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  users.extraUsers.franc = {
   shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
	"docker"
	"dotenv"
	"docker-compose"
      ];
      theme = "agnoster";
    };

    histSize = 20000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   zoxide
   easyeffects
   equibop
   streamrip
   kdePackages.ghostwriter
   localsend
   nicotine-plus
   qbittorrent
   zed-editor
   wezterm
   gearlever
   resources
   plexamp
   yazi
   file
   python311
   gcc
   cudaPackages.cudatoolkit
   julia-bin
   fastfetch
   lmstudio
   uv
   ruff
   cava
   qdirstat
   ntfs3g
   docker-compose
   docker
   mako
   wl-clipboard
   slurp
   #inputs.zen-browser.packages."${system}".default
   #inputs.zen-browser.packages."${system}".specific
  ];

#fonts.packages = with pkgs; [

#  inter
#  julia-mono

#];

fonts = {

  packages = with pkgs; [
 
  inter
  julia-mono
  ];

  fontconfig = {

      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = [ "Julia Mono" ];
        sansSerif = [ "Inter" ];
        serif = [ "Inter" ];

  };
};
};

fileSystems."/home/franc/vault" = {
   device = "/dev/disk/by-uuid/066282B46282A7CF";
   fsType = "ntfs";
   options = [ # If you don't have this options attribute, it'll default to "defaults" 
     # boot options for fstab. Search up fstab mount options you can use
     "users" # Allows any user to mount and unmount
     "nofail" # Prevent system from failing if this drive doesn't mount
     
   ];
 };




#  services.plex = {
#  enable = true;
#  openFirewall = true;
#};

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  #services.gnome.gnome-keyring.enable = true;

  # enable Sway window manager
  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?

}
