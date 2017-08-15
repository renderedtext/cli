class Sem::CLI::Orgs < Sem::ThorExt::SubcommandThor
  namespace "orgs"

  desc "list", "list organizations"
  def list
    orgs = [
      ["ID", "NAME"],
      ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext"],
      ["fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", "tb-render"]
    ]

    print_table(orgs)
  end

  desc "info", "shows detailed information about an organization"
  def info(_org_name)
    org = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", "renderedtext"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(org)
  end

  desc "members", "list members of an organization"
  method_option :with_2fa,
                :default => false,
                :type => :boolean,
                :desc => "list members that have two factor authentication enabled"
  method_option :admins,
                :default => false,
                :type => :boolean,
                :desc => "list only admins in the organization"
  method_option :owners,
                :default => false,
                :type => :boolean,
                :desc => "list only owners in the organization"
  def members(_org_name)
    orgs = [
      ["ID", "NAME", "PERMISSION", "2FA"],
      ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "ijovan", "write", "true"],
      ["fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", "shiroyasha", "admin", "true"]
    ]

    print_table(orgs)
  end

end
