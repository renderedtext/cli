class Sem::API::Team < SimpleDelegator
  extend Sem::API::Base

  def self.all
    projects = Sem::API::Org.all.pmap { |org| client.teams.list_for_org(org.username) }

    projects.flatten.map { |project| new(project) }
  end

  def self.find(org_name, team_name)
    team = client.teams.list_for_org(org_name, :name => team_name).first

    new(org_name, team) if team
  end

  def self.create(org_name, args)
    team = api.create_for_org!(org_name, args)

    new(org_name, team)
  end

  attr_reader :org_name

  def initialize(org_name, team)
    @org_name = org_name

    super(team)
  end

  def full_name
    "#{org_name}/#{name}"
  end

  def update
    new(api.update!(team.id, args))
  end

  def delete
    client.projects.delete!(id)
  end

  def users
    client.users.list_for_team(id).map { |user| Sem::API::User.new(user) }
  end

  def projects
    client.projects.list_for_team(id).map { |team| Sem::API::Project.new(org_name, project) }
  end

end
