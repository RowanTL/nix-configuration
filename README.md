# Overview

This repo contains my NixOS configuration files.

## Tree Structure

### hosts folder

This folder holds the code for the machines that share this configuration. My main
machine is `rowan-laptop` at the moment.

### modules folder

This is split into to main categories. I have configuration used by home-manager and
configuration used by nix directly. This is subject to change as I learn more.

Basically the `home` folder contains configurations I use exclusively for `home-manager`. The
`os` folder contains configurations used exclusively by the various `configuration.nix`s.

The `default.nix` files contain configuration I deem common among my various machines.
