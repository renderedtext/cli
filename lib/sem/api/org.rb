class Sem::API::Org < SimpleDelegator
  extend Sem::API::Base

  def self.all
    client.orgs.list!.map { |org| new(org) }
  end

  def self.find!(org_name)
    new(client.orgs.get!(org_name))
  rescue SemaphoreClient::Exceptions::NotFound
    raise Sem::Errors::ResourceNotFound.new("Organization", [org_name])
  end

  def users
    Sem::API::Base.client.users.list_for_org!(username).map { |user| Sem::API::User.new(user) }
  end

  def teams
    Sem::API::Base.client.teams.list_for_org!(username).map { |team| Sem::API::Team.new(username, team) }
  end

  def projects
    Sem::API::Base.client.projects.list_for_org!(username).map { |project| Sem::API::Project.new(username, project) }
  end

  def shared_configs
    Sem::API::Base.client.shared_configs.list_for_org!(username).map { |config| Sem::API::SharedConfig.new(username, config) }
  end

end
