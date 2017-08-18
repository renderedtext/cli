class Sem::CLI::Orgs < Dracula

  desc "list", "list organizations"
  def list
    orgs = Sem::API::Orgs.list

    Sem::Views::Orgs.list(orgs)
  end

  desc "info", "shows detailed information about an organization"
  def info(org_name)
    org = Sem::API::Orgs.info(org_name)

    Sem::Views::Orgs.info(org)
  end

  desc "members", "list members of an organization"
  option :with_2fa,
         :default => false,
         :type => :boolean,
         :desc => "list members that have two factor authentication enabled"
  option :admins,
         :default => false,
         :type => :boolean,
         :desc => "list only admins in the organization"
  option :owners,
         :default => false,
         :type => :boolean,
         :desc => "list only owners in the organization"
  def members(org_name)
    raise "Not Implemented" if options[:with_2fa]

    users =
      if options[:owners]
        Sem::API::UsersWithPermissions.list_owners_for_org(org_name)
      elsif options[:admins]
        Sem::API::UsersWithPermissions.list_admins_for_org(org_name)
      else
        Sem::API::UsersWithPermissions.list_for_org(org_name)
      end

    Sem::Views::UsersWithPermissions.list(users)
  end

end
