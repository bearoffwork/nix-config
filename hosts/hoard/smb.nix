{ pkgs, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "hoard";
        "netbios name" = "HOARD";
        "security" = "user";
        "invalid users" = [ "root" ];

        # SMB3 only, multichannel for dual 10GbE
        "server min protocol" = "SMB3_11";
        "server multi channel support" = "yes";

        # Performance: large files over 10GbE
        "use sendfile" = "yes";
        "aio read size" = "1";
        "aio write size" = "1";
        "max xmit" = "1048576";
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=1048576 SO_SNDBUF=1048576";
        "read raw" = "yes";
        "write raw" = "yes";
      };

      # VAM library / Windows D: (pilot — switch to iSCSI zvol if SMB misbehaves)
      "ws-d" = {
        "path" = "/tank/bear/ws-d";
        "browseable" = "yes";
        "read only" = "no";
        "valid users" = "@smbusers";
        "force user" = "bear";
        "create mask" = "0664";
        "directory mask" = "0775";

        "acl allow execute always" = "yes";
      };
    };
  };

  environment.systemPackages = [ pkgs.samba ];
}
