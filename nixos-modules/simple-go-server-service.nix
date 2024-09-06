{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:

with lib;

let

  cfg = config.services.simple-go-server;

in

{
  ###### interface
  options = {

    services.simple-go-server = rec {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run the simple-go-server
        '';
      };

      # the simple-go-server does not actually support specifying a port 
      # so this actually does nothing, but it could/should be picked up and 
      # inserted into the systemd config for the service
      port = mkOption {
        type = types.int;
        default = 8080;
        description = ''
          The port to run the service on 
        '';
      };
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    users.extraGroups.simple-go-server = { };

    users.extraUsers.simple-go-server = {
      description = "simple-go-server";
      group = "simple-go-server";
      # home = baseDir;
      isSystemUser = true;
      useDefaultShell = true;
    };

    environment.systemPackages = [ pkgs.simple-go-server ];

    systemd.services.simple-go-server = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # the binary generated in this repo is called simple-rest-api and not 
        # simple-go-server.
        ExecStart = "${pkgs.simple-go-server}/bin/simple-rest-api";
        User = "simple-go-server";
        PermissionsStartOnly = true;
        Restart = "always";
      };
    };

  };

}
