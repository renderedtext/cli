class Sem::API::Secret < SimpleDelegator
  extend Sem::API::Base

  def self.all
    Sem::API::Org.all.pmap(&:shared_configs).flatten
  end

  def self.find!(secrets_srn)
    org_name, secret_name = Sem::SRN.parse_secrets(shared_config_srn)

    configs = client.shared_configs.list_for_org!(org_name)
    config = configs.find { |c| c.name == shared_config_name }

    if config.nil?
      raise Sem::Errors::ResourceNotFound.new("Secret", [org_name, shared_config_name])
    end

    new(org_name, config)
  rescue SemaphoreClient::Exceptions::NotFound
    raise Sem::Errors::ResourceNotFound.new("Secret", [org_name, shared_config_name])
  end

  def self.create!(shared_config_srn, args = {})
    org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config_srn)

    shared_config = client.shared_configs.create_for_org!(org_name, args.merge(:name => shared_config_name))

    if shared_config.nil?
      raise Sem::Errors::ResourceNotCreated.new("Secret", [org_name, shared_config_name])
    end

    new(org_name, shared_config)
  end

  attr_reader :org_name

  def initialize(org_name, shared_config)
    @org_name = org_name

    super(shared_config)
  end

  def full_name
    "#{org_name}/#{name}"
  end

  def add_config_file(args)
    file = Sem::API::Base.client.config_files.create_for_shared_config!(id, args)

    if file.nil?
      raise Sem::Errors::ResourceNotCreated.new("Configuration File", [org_name, path])
    end

    Sem::API::File.new(file)
  end

  def remove_config_file(path)
    file = files.find { |f| f.path == path }

    if file.nil?
      raise Sem::Errors::ResourceNotCreated.new("Configuration File", [org_name, path])
    end

    Sem::API::Base.client.config_files.delete!(file.id)
  end

  def add_env_var(args)
    env_var = Sem::API::Base.client.env_vars.create_for_shared_config!(id, args)

    if env_var.nil?
      raise Sem::Errors::ResourceNotCreated.new("Environment Variable", [org_name, args[:name]])
    end

    Sem::API::EnvVar.new(env_var)
  end

  def remove_env_var(name)
    env_var = env_vars.find { |var| var.name == name }

    if env_var.nil?
      raise Sem::Errors::ResourceNotFound.new("Environment Variable", [org_name, name])
    end

    Sem::API::Base.client.env_vars.delete!(env_var.id)
  end

  def update!(args)
    shared_config = Sem::API::Base.client.shared_configs.update!(id, args)

    if shared_config.nil?
      raise Sem::Errors::ResourceNotUpdated.new("Secret", [org_name, name])
    end

    self.class.new(org_name, shared_config)
  end

  def delete!
    Sem::API::Base.client.shared_configs.delete!(id)
  end

  def files
    Sem::API::Base.client.config_files.list_for_shared_config!(id).map { |file| Sem::API::File.new(file) }
  end

  def env_vars
    Sem::API::Base.client.env_vars.list_for_shared_config!(id).map { |env_var| Sem::API::EnvVar.new(env_var) }
  end

end
