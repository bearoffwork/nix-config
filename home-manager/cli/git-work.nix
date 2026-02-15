let
  workProfile = {
    contents = {
      user = {
        email = "bear@eui.money";
        name = "Bear Yu";
      };
    };
  };
in
{
  programs = {
    git = {
      includes = [
        {
          inherit (workProfile) contents;
          condition = "gitdir:~/src/eui/";
        }
        {
          inherit (workProfile) contents;
          condition = "hasconfig:remote.*.url:**/euimoney/**";
        }
      ];
    };
  };
}
