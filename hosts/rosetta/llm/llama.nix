{
  inputs,
  pkgs,
  ...
}:

let

  llama-cpp = pkgs.unstable.llama-cpp-vulkan.overrideAttrs (
    old:
    let
      src = inputs.llama-fork;
    in
    {
      inherit src;

      postPatch = ''
        echo "llama-fork/${src.shortRev or "unknown"}" > COMMIT
      '';
    }
  );
in
{
  services.llama-cpp = {
    enable = false;
    package = llama-cpp;
    host = "::";
    port = 8731;
    openFirewall = true;
  };
}
