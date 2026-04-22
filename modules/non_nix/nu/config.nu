# config.nu
#
# Installed by:
# version = "0.111.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# Run ls in an interactive shell
# and print in color
if $nu.is-interactive {
  print -n (ls | table)
}

$env.config = {
  show_banner: false,
  completions: {
    external: {
      enable: true,
    }
  }
}

$env.PATH = ($env.PATH | append ($nu.home-dir | path join "bin") | append ($nu.home-dir | path join ".local/bin"))

## Setup for carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.CARAPACE_LENIENT = 1 # Fixes pass -c completions
