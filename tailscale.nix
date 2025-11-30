{ config, pkgs, lib, ... }:

{
	services.tailscale = {
		enable = true;
		package = pkgs.tailscale.overrideAttrs (old: rec {
			version = "1.90.9";
			src = pkgs.fetchFromGitHub {
				owner = "tailscale";
				repo = "tailscale";
				rev = "v${version}";
				hash = lib.fakeSha256; # replace with actual hash
			};
		});
	};
}
