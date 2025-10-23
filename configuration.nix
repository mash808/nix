# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[
			./hardware-configuration.nix
			./cachix.nix
		];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	
	# disable all sleep/suspend states
	systemd.sleep.extraConfig = ''
		AllowSuspend=no
		AllowHibernation=no
		AllowSuspendThenHibernate=no
		AllowHybridSleep=no
	'';

	systemd.targets.sleep.enable = false;
	systemd.targets.suspend.enable = false;
	systemd.targets.hibernate.enable = false;
	systemd.targets.hybrid-sleep.enable = false;

	networking.hostName = "nixos"; # Define your hostname.
	networking.networkmanager.enable = true;

	time.timeZone = "Australia/Brisbane";

	i18n.defaultLocale = "en_GB.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_AU.UTF-8";
		LC_IDENTIFICATION = "en_AU.UTF-8";
		LC_MEASUREMENT = "en_AU.UTF-8";
		LC_MONETARY = "en_AU.UTF-8";
		LC_NAME = "en_AU.UTF-8";
		LC_NUMERIC = "en_AU.UTF-8";
		LC_PAPER = "en_AU.UTF-8";
		LC_TELEPHONE = "en_AU.UTF-8";
		LC_TIME = "en_AU.UTF-8";
	};

	services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

	services.xserver.xkb = {
		layout = "au";
		variant = "";
	};

	# fix the hardware graphics acceleration situation with nvidia + wayland (hopefully)
	hardware.nvidia.open = true;
	boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
	hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = with pkgs; [
			nvidia-vaapi-driver
			libva-vdpau-driver
			libvdpau-va-gl
		];
	};

	environment.variables = {
		NVD_BACKEND = "direct";
		LIBVA_DRIVER_NAME = "nvidia";
		NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
	};

	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia.modesetting.enable = true; # force nvidia driver to work under Wayland compositors
	hardware.nvidia.nvidiaSettings = true;

	services.printing.enable = true;

	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	users.users.ash = {
		isNormalUser = true;
		description = "ash";
		extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.nushell;
		packages = with pkgs; [
			kdePackages.kate
			vlc
			gimp
			steam
			discord
		];
	};

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	programs.firefox.enable = true;
	programs.steam.enable = true;
	programs.steam.gamescopeSession.enable = true;
	programs.gamemode.enable = true;
	programs.obs-studio = {
		enable = true;
		package = pkgs.obs-studio.override { cudaSupport = true; };
	};

	programs.ssh.startAgent = true;

	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
			neovim
			wget
			openssl
			cmake
			pkg-config
			curl
			git
			nushell
			libva-utils
			nv-codec-headers-12
			fastfetch
			ghostty
			kitty
			pciutils
			mpv
			easyeffects
			mangohud
			protonup-qt
			lutris
			bottles
	];

	# nushell is not POSIX compliant, so launch it from bash instead of setting as login shell
	environment.shells = [
		pkgs.nushell
	];
	programs.bash.interactiveShellInit = ''
		if ! [ "$TERM" = "dumb" ]; then
			exec nu
		fi
	'';

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?
}
