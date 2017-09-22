class Sem::CLI::Orgs < Dracula

  desc "list", "list organizations"
  def list
    Sem::Views::Orgs.list(Sem::API::Org.all)
  end

  desc "info", "shows detailed information about an organization"
  def info(org)
    org_name = Sem::SRN.parse_org(org).first
    org = Sem::API::Org.find(org_name)

    Sem::Views::Orgs.info(org)
  end

  desc "members", "list members of an organization"
  def members(org)
    org_name = Sem::SRN.parse_org(org).first
    org = Sem::API::Org.find(org_name)

    abort "Organization #{org_name} not found." unless org

    Sem::Views::Users.list(org.users)
  end

end
