{
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.services.dnsmasq;
  mapA = f: attrs: with builtins; attrValues (mapAttrs f attrs);
in

{
  options = {

    services.dnsmasq.cnames = mkOption {
      type = types.attrs;
      default = { };
      description = "List of domains that will be redirected by the DNSmasq.";
      example = literalExpression ''
        { "example.com" = "cname.example.com"; }
      '';
    };

  };

  config = {

    services.dnsmasq = {
      enable = true;
      bind = "127.0.0.1";
      # bind = "0.0.0.0";
      port = 53;
      servers = [
        "1.1.1.1"
        "168.95.1.1"
      ];
      addresses = {
        "test" = "127.0.0.1";
        # "ph.eui.money" = "166.117.64.23";
        # "ph.transaction.eui.money" = "166.117.64.23";
        # "ph.admin.eui.money" = "166.117.64.23";
      };
      # cnames = {
      #   "ph.eui.money" = "remit-ph-853570513.ap-east-2.elb.amazonaws.com";
      #   "ph.transaction.eui.money" = "remit-ph-853570513.ap-east-2.elb.amazonaws.com";
      #   "ph.admin.eui.money" = "remit-ph-853570513.ap-east-2.elb.amazonaws.com";
      # };
    };

    launchd.daemons.dnsmasq.command = lib.mkForce (
      let
        baseArgs = [
          "--listen-address=${cfg.bind}"
          "--port=${toString cfg.port}"
          "--keep-in-foreground"
        ]
        ++ (mapA (domain: addr: "--address=/${domain}/${addr}") cfg.addresses)
        ++ (map (server: "--server=${server}") cfg.servers)
        ++ (mapA (domain: cname: "--cname=${domain},${cname}") cfg.cnames);
      in
      "${cfg.package}/bin/dnsmasq ${lib.concatStringsSep " " baseArgs}"
    );

    environment.etc = {
      # "resolver/eui.money" = {
      #   text = ''
      #     nameserver 127.0.0.1
      #   '';
      # };
      "resolver/th-dev.internal" = {
        text = ''
          nameserver 172.18.0.2
        '';
      };
    };

  };
}
