class Sem::CLI::Orgs < Dracula

  desc "list", "list organizations"
  def list
    orgs = Sem::API::Orgs.list

    Sem::Views::Orgs.list(orgs)
  end

  desc "info", "shows detailed information about an organization"
  def info(org)
    org_name = Sem::SRN.parse_org(org).first

    org_instance = Sem::API::Orgs.info(org_name).to_h

    Sem::Views::Orgs.info(org_instance)
  end

  desc "members", "list members of an organization"
  def members(org)
    org_name = Sem::SRN.parse_org(org).first

    users = Sem::API::Users.list_for_org(org_name)

    Sem::Views::Users.list(users)
  end

end
