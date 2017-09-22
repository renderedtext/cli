class Sem::CLI::Orgs < Dracula

  desc "list", "list organizations"
  def list
    Sem::Views::Orgs.list(Sem::API::Org.all)
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
