{
  description = "Udev rules for JTAG and similar debug probes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "probe-rs-rules";
          src = self;
          installPhase = ''
            mkdir -p $out/lib/udev/rules.d
            cp 69-probe-rs.rules $out/lib/udev/rules.d/
          '';
        };

        nixosModules.default = { config, pkgs, lib, ... }:
        let
          inherit (lib) mkOption mkIf types;
          cfg = config.hardware.probe-rs;
        in
        {
          options.hardware.probe-rs = {
            enable = mkOption {
              type = types.bool;
              default = false;
              description = lib.mkDoc "Add udev permissions for various probes.";
            };
          };
          config = mkIf cfg.enable {
            services.udev.packages = [ packages.default ];
          };
        };
      }
  );
}
