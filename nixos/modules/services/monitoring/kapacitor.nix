{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kapacitor;

  configFile = pkgs.runCommand "config.toml" {
    buildInputs = [ pkgs.remarshal ];
  } ''
    remarshal -if json -of toml \
      < ${pkgs.writeText "config.json" (builtins.toJSON cfg.extraConfig)} \
      > $out
  '';
in {
  ###### interface
  options = {
    services.kapacitor = {
      enable = mkEnableOption "kapacitor server";

      package = mkOption {
        default = pkgs.kapacitor;
        defaultText = "pkgs.kapacitor";
        description = "Which kapacitor derivation to use";
        type = types.package;
      };

      extraConfig = mkOption {
        default = {};
        description = "Extra configuration options for kapacitor";
        type = types.attrs;
        example = {
          http = {
            bind-address = ":9092";
            auth-enabled = false;
          };
          influxdb = {
            enabled = true;
            name = "default";
            urls = ["http://localhost:8086"];
          };
          logging = {
            file = "STDERR";
            level = "INFO";
          };
          inputs = {
            statsd = {
              service_address = ":8125";
              delete_timings = true;
            };
          };
        };
      };
    };
  };


  ###### implementation
  config = mkIf config.services.kapacitor.enable {
    systemd.services.kapacitor = {
      description = "kapacitor Agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        ExecStart=''${cfg.package}/bin/kapacitord -config "${configFile}"'';
        ExecReload="${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "kapacitor";
        Restart = "on-failure";
      };
    };

    users.extraUsers = [{
      name = "kapacitor";
      description = "kapacitor daemon user";
    }];
  };
}
