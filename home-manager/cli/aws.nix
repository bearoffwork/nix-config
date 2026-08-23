{
  outputs,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    ssm-session-manager-plugin
  ];
  programs.awscli = {
    enable = true;
    # settings = {
    #   "sso-session eui-tpe" = {
    #     sso_region = "ap-east-2";
    #     sso_start_url = "https://eui-tpe.awsapps.com/start";
    #   };
    #   "profile 0263-bear" = {
    #     region = "ap-northeast-1";
    #     output = "json";
    #   };
    #   "profile 0263-cwro" = {
    #     role_arn = "arn:aws:iam::026374454234:role/cloudwatch-readonly";
    #     source_profile = "0263-bear";
    #     region = "ap-northeast-1";
    #     output = "json";
    #   };
    #   "profile 0263-ro" = {
    #     role_arn = "arn:aws:iam::026374454234:role/readonly-anything";
    #     source_profile = "0263-bear";
    #     region = "ap-northeast-1";
    #     output = "json";
    #   };
    #   "profile 0424-bear" = {
    #     region = "ap-northeast-1";
    #     output = "json";
    #   };
    #   "profile audit-admin" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "617029294933";
    #     sso_role_name = "AWSAdministratorAccess";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile mgmt-admin" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "607853595894";
    #     sso_role_name = "AWSAdministratorAccess";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile 0734-admin" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "073419086835";
    #     sso_role_name = "AWSAdministratorAccess";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile 0734-bear" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "073419086835";
    #     sso_role_name = "InfraTeam";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile 0734-ro" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "073419086835";
    #     sso_role_name = "AWSReadOnlyAccess";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile 2680-admin" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "268054298234";
    #     sso_role_name = "AWSAdministratorAccess";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile 2680-bear" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "268054298234";
    #     sso_role_name = "InfraTeam";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile 2680-ro" = {
    #     sso_session = "eui-tpe";
    #     sso_account_id = "268054298234";
    #     sso_role_name = "AWSReadOnlyAccess";
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   "profile 2680-tf-ro" = {
    #     role_arn = "arn:aws:iam::268054298234:role/tfexec-readonly";
    #     source_profile = "2680-admin";
    #     region = "ap-northeast-1";
    #     output = "json";
    #   };
    #   "profile 0734-nathan" = {
    #     region = "ap-east-2";
    #     output = "json";
    #   };
    #   # "profile agent-svc" = {
    #   #   region = "ap-northeast-1";
    #   #   output = "json";
    #   # };
    #   # "profile tw-apne1-kyc-agent" = {
    #   #   role_arn = "arn:aws:iam::026374454234:role/kyc-agent";
    #   #   source_profile = "tw-apne1";
    #   #   region = "ap-northeast-1";
    #   #   output = "json";
    #   # };
    #   # "profile tw-apne1-cwro" = {
    #   #   role_arn = "arn:aws:iam::026374454234:role/cloudwatch-readonly";
    #   #   source_profile = "tw-apne1";
    #   #   region = "ap-northeast-1";
    #   #   output = "json";
    #   # };
    #   # "profile tw-ape2" = {
    #   #   region = "ap-east-2";
    #   #   output = "json";
    #   # };
    #   # "profile tw-ape2-opentf-admin" = {
    #   #   role_arn = "arn:aws:iam::026374454234:role/opentf-iam-admin-role";
    #   #   source_profile = "tw-ape2";
    #   #   region = "ap-east-2";
    #   #   output = "json";
    #   # };
    #   # "profile th-event-actions" = {
    #   #   role_arn = "arn:aws:iam::026374454234:role/service-role/codebuild-th-event-actions-service-role";
    #   #   source_profile = "tw-ape2";
    #   #   region = "ap-east-2";
    #   #   output = "json";
    #   # };
    # };
  };
}
