{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.nginx-vts;
in
{
  port = 9913;
  extraOpts = {
    scrapeUri = mkOption {
      type = types.str;
      default = "http://localhost/status/format/json";
      description = ''
        Address to access the nginx status page.
      '';
    };
    telemetryEndpoint = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
    insecure = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Ignore server certificate if using https.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-nginx-vts-exporter}/bin/nginx-vts-exporter \
          --nginx.scrape_uri '${cfg.scrapeUri}' \
          --telemetry.address ${cfg.listenAddress}:${toString cfg.port} \
          --telemetry.endpoint ${cfg.telemetryEndpoint} \
          --insecure ${toString cfg.insecure} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
