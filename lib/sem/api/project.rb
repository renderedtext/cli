class Sem::API::Project < SimpleDelegator
  extend Sem::API::Base

  def self.all
    Sem::API::Org.all.map do |org|
      client.projects.list_for_org(org.username).map { |project| new(org.username, project) }
    end.flatten
  end

  def self.find!(project_srn)
    org_name, project_name = Sem::SRN.parse_project(project_srn)

    # TODO: fix .to_a bug in client

    project = client.projects.list_for_org(org_name, :name => project_name).to_a.first

    raise Sem::Errors::ResourceNotFound.new("Project", [org_name, project_name]) if project.nil?

    new(org_name, project)
  end

  attr_reader :org_name

  def initialize(org_name, project)
    @org_name = org_name

    super(project)
  end

  def full_name
    "#{@org_name}/#{name}"
  end

  def teams
    client.teams.list_for_project(id).map { |team| Sem::API::Team.new(org_name, team) }
  end

  def shared_configs
    Sem::API::Base.client.shared_configs.list_for_project(id).map { |project| Sem::API::SharedConfig.new(org_name, project) }
  end

  def users

  end

  def files

  end

  def env_vars

  end

end
