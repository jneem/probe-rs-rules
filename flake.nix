{
  description = "Udev rules for JTAG and similar debug probes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }: 
  let 
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  rec {
    packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
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
          description = lib.mkDoc "TODO";
        };
      };
      config = mkIf cfg.enable {
        services.udev.packages = [ packages.x86_64-linux.default ];
      };
    };
  };
}
