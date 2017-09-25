class Sem::API::Team < SimpleDelegator
  extend Sem::API::Base

  def self.all
    Sem::API::Org.all.pmap do |org|
      client.teams.list_for_org(org.username).map { |team| new(org.username, team) }
    end.flatten
  end

  def self.find!(team_srn)
    org_name, team_name = Sem::SRN.parse_team(team_srn)

    team = client.teams.list_for_org(org_name).find { |t| t.name == team_name }

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
    if args[:name]
      new_org_name, new_name = Sem::SRN.parse_team(args[:name])

      abort "Team can't change its organization" unless new_org_name == org_name

      args[:name] = new_name
    end

    new_team = Sem::API::Base.client.teams.update(id, args)

    raise Sem::Errors::ResourceNotUpdated.new("Team", [@org_name, name]) unless new_team

    self.class.new(@org_name, new_team)
  end

  def add_user(username)
    Sem::API::Base.client.users.attach_to_team(username, id)
  end

  def remove_user(username)
    Sem::API::Base.client.users.detach_from_team(username, id)
  end

  def add_project(project)
    Sem::API::Base.client.projects.attach_to_team(project.id, id)
  end

  def remove_project(project)
    Sem::API::Base.client.projects.detach_from_team(project.id, id)
  end

  def add_shared_config(config)
    Sem::API::Base.client.shared_configs.attach_to_team(config.id, id)
  end

  def remove_shared_config(config)
    Sem::API::Base.client.shared_configs.detach_from_team(config.id, id)
  end

  def delete!
    Sem::API::Base.client.teams.delete(id)
  end

  def users
    Sem::API::Base.client.users.list_for_team(id).map { |user| Sem::API::User.new(user) }
  end

  def projects
    Sem::API::Base.client.projects.list_for_team(id).map { |project| Sem::API::Project.new(org_name, project) }
  end

  def shared_configs
    Sem::API::Base.client.shared_configs.list_for_team(id).map { |config| Sem::API::SharedConfig.new(org_name, config) }
  end

end
