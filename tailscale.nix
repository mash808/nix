{ config, pkgs, ... }:

let
	# fetch a newer nixpkgs that has the updated tailscale
	latestPkgs = import (pkgs.fetchFromGitHub {
		owner = "NixOS";
		repo = "nixpkgs";
		rev = "13cf9b94f25031451505a17b84fcbb15c6622890";
		hash = "sha256-dl/9o7iOLdjxheu8rNPuY+Y4ObILFyg+f+kMqE+7Ngg=";
	}) { inherit (pkgs) system; };
in
{
	services.tailscale = {
		enable = true;
		package = latestPkgs.tailscale; 
	};
}
