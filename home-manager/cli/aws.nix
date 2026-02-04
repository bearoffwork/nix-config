{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stable.ssm-session-manager-plugin
  ];
  programs.awscli = {
    enable = true;
    package = pkgs.awscli2;
    settings = {
      "profile tw-apne1" = {
        region = "ap-northeast-1";
        output = "json";
      };
      "profile agent-svc" = {
        region = "ap-northeast-1";
        output = "json";
      };
      "profile tw-apne1-kyc-agent" = {
        role_arn = "arn:aws:iam::026374454234:role/kyc-agent";
        source_profile = "tw-apne1";
        region = "ap-northeast-1";
        output = "json";
      };
      "profile tw-apne1-cwro" = {
        role_arn = "arn:aws:iam::026374454234:role/cloudwatch-readonly";
        source_profile = "tw-apne1";
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
      "profile tpe-ape2" = {
        region = "ap-east-2";
        output = "json";
      };
      "profile tpe-ape2-ro" = {
        role_arn = "arn:aws:iam::073419086835:role/global-ro";
        source_profile = "tpe-ape2";
        region = "ap-east-2";
        output = "json";
      };
      "profile tpe-ape2-test" = {
        region = "ap-east-2";
        output = "json";
      };
    };
  };
}
