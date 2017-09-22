class Sem::API::SharedConfig < SimpleDelegator
  extend Sem::API::Base

  def self.all
    configs = Sem::API::Org.all.pmap { |org| client.shared_configs.list_for_org(org.username) }

    configs.flatten.map { |config| new(config) }
  end

  def self.find(org_name, shared_config_name)
    configs = client.shared_configs.list_for_org(org_name)
    config = configs.find { |config| config[:name] == shared_config_name }

    if config.nil?
      raise Sem::Errors::ResourceNotFound.new("Shared Configuration", [org_name, shared_config_name])
    end

    new(selected_shared_config)
  end

  def self.create(org_name, shared_config_name, args)
    shared_config = api.create_for_org(org_name, args)

    if shared_config.nil?
      raise Sem::Errors::ResourceNotCreated.new("Shared Configuration", [org_name, args[:name]])
    end

    new(shared_config)
  end

  def self.update(org_name, shared_config_name, args)
    shared_config = info(org_name, shared_config_name)

    shared_config = api.update(shared_config[:id], args)

    if shared_config.nil?
      raise Sem::Errors::ResourceNotUpdated.new("Shared Configuration", [org_name, shared_config_name])
    end

    new(shared_config)
  end

  def self.delete(org_name, shared_config_name)
    shared_config = find(org_name, shared_config_name)

    api.delete!(shared_config.id)
  end

  attr_reader :org_name

  def initialize(org_name, shared_config)
    @org_name = org_name

    super(shared_config)
  end

  def full_name
    "#{org_name}/#{name}"
  end

  def teams
    client.teams.list_for_shared_config(id).map { |team| Sem::API::Team.new(org_name, team) }
  end

  def projects
    client.project.list_for_shared_config(id).map { |project| Sem::API::Project.new(org_name, project) }
  end

  def files
    client.config_files.list_for_shared_config(id).map { |file| Sem::API::File.new(org_name, file) }
  end

  def env_vars
    client.env_vars.list_for_shared_config(id).map { |env_var| Sem::API::EnvVars.new(org_name, env_var) }
  end

end
