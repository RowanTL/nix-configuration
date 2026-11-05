# Overview

This repo contains my NixOS configuration files.

## Tree Structure

### hosts folder

Machine specific configuration. My main is `rowan-laptop`.

### modules folder

This is split into to two main categories: configuration for each user in `modules/os` and configuration
for my user at `modules/home`.

The `default.nix` files contain configuration I deem common among my various machines.
