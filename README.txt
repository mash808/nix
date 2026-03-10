will prob switch to a home manager setup when this starts to feel a bit larger or i start to use on more devices. works well for my needs: dev, gaming, general use. can use "age" for secrets etc if i start adding keys for different things like SSH.


to use this configuration:
`sudo nix flake update` to upgrade pinned packages (flake.lock) to newest versions -- or you can keep as is if you don't mind
`sudo nixos-rebuild switch --flake /etc/nixos#nixos --upgrade` to switch to it (and upgrade nixos if there's a new version available)
