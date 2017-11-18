class Sem::CLI::Orgs < Dracula

  desc "list", "List all organizations"
  long_desc <<-DESC.strip_heredoc
    Examples:

      $ sem orgs:list
      ID                                    NAME
      5bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext
      99c7ed43-ac8a-487e-b488-c38bc757a034  z-fighters
  DESC
  def list
    orgs = Sem::API::Org.all

    if !orgs.empty?
      Sem::Views::Orgs.list(orgs)
    else
      Sem::Views::Orgs.create_first_org
    end
  end

  desc "info", "shows detailed information about an organization"
  long_desc <<-DESC.strip_heredoc
    Examples:

      $ sem orgs:info renderedtext
      ID       5bc7ed43-ac8a-487e-b488-c38bc757a034
      Name     renderedtext
      Created  2017-08-01 13:14:40 +0200
      Updated  2017-08-02 13:14:40 +0200
  DESC
  def info(org_name)
    org = Sem::API::Org.find!(org_name)

    Sem::Views::Orgs.info(org)
  end

  desc "members", "list members of an organization"
  long_desc <<-DESC.strip_heredoc
    Examples:

      $ sem orgs:members renderedtext
      NAME
      darko
      shiroyasha
      bmarkons
  DESC
  def members(org_name)
    org = Sem::API::Org.find!(org_name)

    Sem::Views::Users.list(org.users)
  end

end
