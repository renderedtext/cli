class Sem::CLI::SharedConfigs < Dracula

  desc "list", "list shared cofigurations"
  def list
    shared_configs = Sem::API::SharedConfig.all

    Sem::Views::SharedConfigs.list(shared_configs)
  end

  desc "info", "show information about a shared configuration"
  def info(shared_config_name)
    shared_config = Sem::API::SharedConfig.find!(shared_config_name)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "create", "create a new shared configuration"
  def create(shared_config_name)
    shared_config = Sem::API::SharedConfig.create!(shared_config)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "rename", "rename a shared configuration"
  def rename(old_shared_config, new_shared_config)
    shared_config = Sem::API::SharedConfig.find!(old_shared_config_name)
    shared_config = shared_config.update!(:name => new_shared_config_name)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "delete", "removes a shared configuration from your organization"
  def delete(shared_config_name)
    Sem::API::SharedConfig.delete!(shared_config_name)

    puts "Deleted shared configuration #{shared_config_name}"
  end

  class Files < Dracula

    desc "list", "list files in the shared configuration"
    def list(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      Sem::Views::Files.list(shared_config.files)
    end

    desc "add", "add a file to the shared configuration"
    option :file, :aliases => "f", :desc => "File to upload", :required => true
    def add(shared_config_name, file)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      shared_config.add_config_file(:path => file, :content => File.read(options[:file]))

      puts "Added #{file} to #{shared_config_name)
    end

    desc "remove", "remove a file from the shared configuration"
    def remove(shared_config_name, file)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      shared_config.remove_file(file)

      puts "Removed #{file} from #{shared_config_name}"
    end

  end

  class EnvVars < Dracula

    desc "list", "list environment variables in the shared configuration"
    def list(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      Sem::Views::EnvVars.list(shared_config.env_vars)
    end

    desc "add", "add an environment variable to the shared configuration"
    option :name, :aliases => "-n", :desc => "Name of the variable", :required => true
    option :content, :aliases => "-c", :desc => "Content of the variable", :required => true
    def add(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      shared_config.add_env_var(:name => options[:name], :content => options[:content])

      puts "Added #{options[:name]} to #{shared_config_name}"
    end

    desc "remove", "remove an environment variable from the shared configuration"
    def remove(shared_config_name, env_var)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      shared_config.remove_env_var(env_var)

      puts "Removed #{env_var} from #{shared_config_name}"
    end

  end

  register "files", "manage files", Files
  register "env-vars", "manage environment variables", EnvVars
end
