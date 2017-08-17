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
        Sem::API::Orgs.list_owners(org_name)
      elsif options[:admins]
        Sem::API::Orgs.list_admins(org_name)
      else
        Sem::API::Orgs.list_users(org_name)
      end

    Sem::Views::Users.list(users)
  end

end
