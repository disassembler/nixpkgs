{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    networking.passopolis.enable = mkOption {
      default = false;
      description = ''
        Whether to start passopolis, a java based password manager.
      '';
    };
  };


  ###### implementation

  config = mkIf config.networking.passopolis.enable {

    environment.systemPackages = [pkgs.passopolis];

    systemd.services.passopolis = {
      after = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.jre}/bin/java -ea -jar ${cfg.mitro}/share/java/mitrocore.jar";
    };
  };
}
