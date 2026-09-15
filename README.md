# Overview

This repo contains my NixOS configuration files.

## Tree Structure

### hosts folder

Machine specific configuration. My main is `rowan-laptop`.

### modules folder

This is split into to two main categories: configuration used by home-manager and
configuration for the operation system level.

The `default.nix` files contain configuration I deem common among my various machines.
