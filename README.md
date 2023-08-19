# probe-rs-rules

This repo contains a NixOS module for adding udev permissions for
debug probes used in embedded programming. This module is based on
probe-rs's [instructions](https://probe.rs/docs/getting-started/probe-setup/).

To use this module in a flake-enabled NixOS configuration, add
this repo as an input:

```nix
inputs.probe-rs-rules.url = "github:jneem/probe-rs-rules";
```

Then import the module and set the `hardware.probe-rs.enable` option:

```
imports = [
  probe-rs-rules.nixosModules.${pkgs.system}.default
  # ...and whatever other inputs you have.
];
hardware.probe-rs.enable = true;
```
