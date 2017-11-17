class Sem::API::Secret < SimpleDelegator
  extend Sem::API::Base

  def self.all
    Sem::API::Org.all.pmap(&:secrets).flatten
  end

  def self.find!(secrets_srn)
    org_name, secret_name = Sem::SRN.parse_secret(secrets_srn)

    secrets = client.secrets.list_for_org!(org_name)
    secret = secrets.find { |c| c.name == secret_name }

    if secret.nil?
      raise Sem::Errors::ResourceNotFound.new("Secret", [org_name, secret_name])
    end

    new(org_name, secret)
  rescue SemaphoreClient::Exceptions::NotFound
    raise Sem::Errors::ResourceNotFound.new("Secret", [org_name, secret_name])
  end

  def self.create!(secret_srn, args = {})
    org_name, secret_name = Sem::SRN.parse_secret(secret_srn)

    secret = client.secrets.create_for_org!(org_name, args.merge(:name => secret_name))

    if secret.nil?
      raise Sem::Errors::ResourceNotCreated.new("Secret", [org_name, secret_name])
    end

    new(org_name, secret)
  end

  attr_reader :org_name

  def initialize(org_name, secret)
    @org_name = org_name

    super(secret)
  end

  def full_name
    "#{org_name}/#{name}"
  end

  def add_config_file(args)
    file = Sem::API::Base.client.config_files.create_for_secret!(id, args)

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
    env_var = Sem::API::Base.client.env_vars.create_for_secret!(id, args)

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
    secret = Sem::API::Base.client.secrets.update!(id, args)

    if secret.nil?
      raise Sem::Errors::ResourceNotUpdated.new("Secret", [org_name, name])
    end

    self.class.new(org_name, secret)
  end

  def delete!
    Sem::API::Base.client.secrets.delete!(id)
  end

  def files
    Sem::API::Base.client.config_files.list_for_secret!(id).map { |file| Sem::API::File.new(file) }
  end

  def env_vars
    Sem::API::Base.client.env_vars.list_for_secret!(id).map { |env_var| Sem::API::EnvVar.new(env_var) }
  end

end
