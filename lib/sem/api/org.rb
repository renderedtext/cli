class Sem::API::Org < SimpleDelegator
  extend Sem::API::Base

  def self.all
    client.orgs.list.map { |org| new(org) }
  end

  def self.find!(org_name)
    org = client.orgs.get(org_name)

    raise Sem::Errors::ResourceNotFound.new("Organization", [org_name]) if org.nil?

    new(org)
  end

  def users
    client.users.list_for_org(name).map { |user| Sem::API::User.new(user) }
  end

  def teams
    client.teams.list_for_org(name).map { |team| Sem::API::Team.new(team) }
  end

  def projects
    client.projects.list_for_org(name).map { |project| Sem::API::Project.new(project) }
  end

end
