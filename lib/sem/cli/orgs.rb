class Sem::CLI::Orgs < Dracula

  desc "list", "list organizations"
  def list
    orgs = Sem::API::Org.all

    if orgs.size > 0
      Sem::Views::Orgs.list(orgs)
    else
      Sem::Views::Orgs.create_first_org
    end
  end

  desc "info", "shows detailed information about an organization"
  def info(org_name)
    org = Sem::API::Org.find!(org_name)

    Sem::Views::Orgs.info(org)
  end

  desc "members", "list members of an organization"
  def members(org_name)
    org = Sem::API::Org.find!(org_name)

    Sem::Views::Users.list(org.users)
  end

end
