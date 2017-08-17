class Sem::CLI::SharedConfigs < Sem::ThorExt::SubcommandThor
  namespace "shared-configs"

  desc "list", "list shared cofigurations"
  def list
    shared_configs = Sem::API::SharedConfigs.list

    Sem::Views::SharedConfigs.list(shared_configs)
  end

  desc "info", "show information about a shared configuration"
  def info(path)
    shared_config = Sem::API::SharedConfigs.info(path)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "create", "create a new shared configuration"
  def create(path)
    org_name, shared_config_name = path.split("/")

    shared_config = Sem::API::SharedConfigs.create(org_name, :name => shared_config_name)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "rename", "rename a shared configuration"
  def rename(old_path, new_path)
    _, name = new_path.split("/")

    shared_config = Sem::API::SharedConfigs.update(old_path, :name => name)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "delete", "removes a shared configuration from your organization"
  def delete(path)
    Sem::API::SharedConfigs.delete(path)

    puts "Deleted shared configuration #{path}"
  end

  class Files < Sem::ThorExt::SubcommandThor
    namespace "shared_configs:files"

    desc "list", "list files in the shared configuration"
    def list(shared_config_path)
      files = Sem::API::SharedConfigs.list_files(shared_config_path)

      Sem::Views::Files.list(files)
    end

    desc "add", "add a file to the shared configuration"
    method_option :file, :aliases => "f", :desc => "File to upload", :required => true
    def add(shared_config_path, file_name)
      content = File.read(options[:file])

      Sem::API::Files.add_to_shared_config(shared_config_path, :path => file_name, :content => content)

      puts "Added #{file_name} to #{shared_config_path}"
    end

    desc "remove", "remove a file from the shared configuration"
    def remove(shared_config_path, file_name)
      Sem::API::Files.remove_from_shared_config(shared_config_path, file_name)

      puts "Removed #{file_name} from #{shared_config_path}"
    end
  end

  desc "files", "manage files", :hide => true
  subcommand "files", Files

  class EnvVars < Sem::ThorExt::SubcommandThor
    namespace "shared_configs:env-vars"

    desc "list", "list environment variables in the shared configuration"
    def list(shared_config_path)
      env_vars = Sem::API::SharedConfigs.list_env_vars(shared_config_path)

      Sem::Views::EnvVars.list(env_vars)
    end

    desc "add", "add an environment variable to the shared configuration"
    method_option :name, :aliases => "-n", :desc => "Name of the variable", :required => true
    method_option :content, :aliases => "-c", :desc => "Content of the variable", :required => true
    def add(shared_config_path)
      Sem::API::EnvVars.add_to_shared_config(shared_config_path,
                                             :name => options[:name],
                                             :content => options[:content])

      puts "Added #{options[:name]} to #{shared_config_path}"
    end

    desc "remove", "remove an environment variable from the shared configuration"
    def remove(shared_config_path, env_var_name)
      Sem::API::EnvVars.remove_from_shared_config(shared_config_path, env_var_name)

      puts "Removed #{env_var_name} from #{shared_config_path}"
    end
  end

  desc "env_vars", "manage environment variables", :hide => true
  subcommand "env_vars", EnvVars
end
