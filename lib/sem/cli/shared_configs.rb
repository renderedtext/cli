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
    def list(_shared_config_name)
      files = [
        ["ID", "NAME", "ENCRYPTED?"],
        ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "secrets.txt", "true"],
        ["37d8fdc0-4a96-4535-a4bc-601d1c7c7058", "config.yml", "true"]
      ]

      print_table(files)
    end

    desc "add", "add a file to the shared configuration"
    method_option :file, :aliases => "f", :desc => "File to upload", :required => true
    def add(shared_config_name, file_name)
      puts "Added #{file_name} to #{shared_config_name}"
    end

    desc "remove", "remove a file from the shared configuration"
    def remove(shared_config_name, file_name)
      puts "Removed #{file_name} from #{shared_config_name}"
    end
  end

  desc "files", "manage files", :hide => true
  subcommand "files", Files

  class EnvVars < Sem::ThorExt::SubcommandThor
    namespace "shared_configs:env-vars"

    desc "list", "list environment variables in the shared configuration"
    def list(_shared_config_name)
      files = [
        ["ID", "NAME", "ENCRYPTED?", "CONTENT"],
        ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "AWS_CLIENT_ID", "true", "-"],
        ["37d8fdc0-4a96-4535-a4bc-601d1c7c7058", "EMAIL", "false", "admin@semaphoreci.com"]
      ]

      print_table(files)
    end

    desc "add", "add an environment variable to the shared configuration"
    method_option :name, :aliases => "-n", :desc => "Name of the variable", :required => true
    method_option :content, :aliases => "-c", :desc => "Content of the variable", :required => true
    def add(shared_config_name)
      puts "Added #{options[:name]} to #{shared_config_name}"
    end

    desc "remove", "remove an environment variable from the shared configuration"
    def remove(shared_config_name, env_var)
      puts "Removed #{env_var} from #{shared_config_name}"
    end
  end

  desc "env_vars", "manage environment variables", :hide => true
  subcommand "env_vars", EnvVars
end
