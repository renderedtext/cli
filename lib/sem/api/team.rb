class Sem::API::Team < SimpleDelegator
  extend Sem::API::Base

  def self.all
    teams = Sem::API::Org.all.pmap do |org|
      client.teams.list_for_org(org.username).map { |team| new(org.username, team) }
    end.flatten
  end

  def self.find!(team_srn)
    org_name, team_name = Sem::SRN.parse_team(team_srn)

    team = client.teams.list_for_org(org_name).find { |team| team.name == team_name }

    raise Sem::Errors::ResourceNotFound.new("Team", [org_name, team_name]) if team.nil?

    new(org_name, team)
  end

  def self.create!(team_srn, args)
    org_name, team_name = Sem::SRN.parse_team(team_srn)

    team = client.teams.create_for_org(org_name, args.merge(:name => team_name))

    raise Sem::Errors::ResourceNotCreated.new("Team", [org_name, team_name]) if team.nil?

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

  def update(args)
    new_team = Sem::API::Base.client.teams.update(id, args)

    raise Sem::Errors::ResourceNotUpdated.new("Team", [@org_name, name]) if new_team.nil?

    self.class.new(@org_name, new_team)
  end

  def delete!
    Sem::API::Base.client.teams.delete(id)
  end

  def users
    Sem::API::Base.client.users.list_for_team(id).map { |user| Sem::API::User.new(user) }
  end

  def projects
    client.projects.list_for_team(id).map { |team| Sem::API::Project.new(org_name, project) }
  end

end
