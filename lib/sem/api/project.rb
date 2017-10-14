class Sem::API::Project < SimpleDelegator
  extend Sem::API::Base

  def self.all
    Sem::API::Org.all.map do |org|
      client.projects.list_for_org(org.username).map { |project| new(org.username, project) }
    end.flatten
  end

  def self.find!(project_srn)
    org_name, project_name = Sem::SRN.parse_project(project_srn)

    projects = client.projects.list_for_org!(org_name, :name => project_name)
    project = projects.to_a.first

    if project.nil?
      raise Sem::Errors::ResourceNotFound.new("Project", [org_name, project_name])
    end

    new(org_name, project)
  rescue SemaphoreClient::Exceptions::NotFound => e
    raise Sem::Errors::ResourceNotFound.new("Project", [org_name, project_name])
  end

  def self.create!(project_srn, args)
    org_name, name = Sem::SRN.parse_project(project_srn)

    project = client.projects.create_for_org!(org_name, args.merge(:name => name))

    new(org_name, project)
  rescue SemaphoreClient::Exceptions::NotFound => e
    raise Sem::Errors::ResourceNotFound.new("Organization", [org_name])
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
    Sem::API::Base.client.shared_configs.list_for_project(id).map { |config| Sem::API::SharedConfig.new(org_name, config) }
  end

  def add_shared_config(shared_config)
    Sem::API::Base.client.shared_configs.attach_to_project(shared_config.id, id)
  end

  def remove_shared_config(shared_config)
    Sem::API::Base.client.shared_configs.detach_from_project(shared_config.id, id)
  end

  def config_files
    Sem::API::Base.client.config_files.list_for_project(id).map { |file| Sem::API::File.new(file) }
  end

  def env_vars
    Sem::API::Base.client.env_vars.list_for_project(id).map { |var| Sem::API::EnvVar.new(var) }
  end

  def add_env_var(env_var)
    Sem::API::Base.client.env_vars.attach_to_project(env_var.id, id)
  end

  def add_config_file(config_file)
    Sem::API::Base.client.config_files.attach_to_project(config_file.id, id)
  end

end
