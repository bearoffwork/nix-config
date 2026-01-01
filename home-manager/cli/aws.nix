{ pkgs, ... }:
{
  programs.awscli = {
    enable = true;
    package = pkgs.awscli2;
    settings = {
      "profile tw-apne1" = {
        region = "ap-northeast-1";
        output = "json";
      };
      "profile tw-ape2" = {
        region = "ap-east-2";
        output = "json";
      };
      "profile tw-ape2-opentf-admin" = {
        role_arn = "arn:aws:iam::026374454234:role/opentf-iam-admin-role";
        source_profile = "tw-ape2";
        region = "ap-east-2";
        output = "json";
      };
      "profile th-event-actions" = {
        role_arn = "arn:aws:iam::026374454234:role/service-role/codebuild-th-event-actions-service-role";
        source_profile = "tw-ape2";
        region = "ap-east-2";
        output = "json";
      };
      "profile jp" = {
        region = "ap-northeast-1";
        output = "json";
      };
    };
  };
}
