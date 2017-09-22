class Sem::CLI::SharedConfigs < Dracula

  desc "list", "list shared cofigurations"
  def list
    shared_configs = Sem::API::SharedConfigs.list

    Sem::Views::SharedConfigs.list(shared_configs)
  end

  desc "info", "show information about a shared configuration"
  def info(shared_config)
    org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

    shared_config_instance = Sem::API::SharedConfigs.info(org_name, shared_config_name).to_h

    Sem::Views::SharedConfigs.info(shared_config_instance)
  end

  desc "create", "create a new shared configuration"
  def create(shared_config)
    org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

    shared_config_instance = Sem::API::SharedConfigs.create(org_name, :name => shared_config_name)

    Sem::Views::SharedConfigs.info(shared_config_instance)
  end

  desc "rename", "rename a shared configuration"
  def rename(old_shared_config, new_shared_config)
    old_org_name, old_shared_config_name = Sem::SRN.parse_shared_config(old_shared_config)
    new_org_name, new_shared_config_name = Sem::SRN.parse_shared_config(new_shared_config)

    if old_org_name != new_org_name
      abort Sem::Views::SharedConfigs.org_names_not_matching("old shared configuration name",
                                                             "new shared configuration name",
                                                             old_shared_config,
                                                             new_shared_config)
    end

    shared_config_instance = Sem::API::SharedConfigs.update(old_org_name,
                                                            old_shared_config_name,
                                                            :name => new_shared_config_name)

    Sem::Views::SharedConfigs.info(shared_config_instance)
  end

  desc "delete", "removes a shared configuration from your organization"
  def delete(shared_config)
    org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

    Sem::API::SharedConfigs.delete(org_name, shared_config_name)

    puts "Deleted shared configuration #{org_name}/#{shared_config_name}"
  end

  class Files < Dracula
    desc "list", "list files in the shared configuration"
    def list(shared_config)
      org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      files = Sem::API::SharedConfigs.list_files(org_name, shared_config_name)

      Sem::Views::Files.list(files)
    end

    desc "add", "add a file to the shared configuration"
    option "local-path", :aliases => "f", :desc => "File to upload", :required => true
    option "path-on-semaphore", :aliases => "p", :desc => "Path of file in builds and deploys", :required => true
    def add(shared_config)
      org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      local_path = options["local-path"]
      path_on_semaphore = options["path-on-semaphore"]

      abort "Local file #{local_path} does not exists." unless File.exist?(local_path)

      Sem::API::Files.add_to_shared_config(org_name,
                                           shared_config_name,
                                           :path => path_on_semaphore,
                                           :content => File.read(local_path))

      puts "Added #{path_on_semaphore} to #{org_name}/#{shared_config_name}"
    end

    desc "remove", "remove a file from the shared configuration"
    def remove(shared_config, file)
      org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      Sem::API::Files.remove_from_shared_config(org_name, shared_config_name, file)

      puts "Removed #{file} from #{org_name}/#{shared_config_name}"
    end
  end

  class EnvVars < Dracula
    desc "list", "list environment variables in the shared configuration"
    def list(shared_config)
      org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      env_vars = Sem::API::SharedConfigs.list_env_vars(org_name, shared_config_name)

      Sem::Views::EnvVars.list(env_vars)
    end

    desc "add", "add an environment variable to the shared configuration"
    option :name, :aliases => "-n", :desc => "Name of the variable", :required => true
    option :content, :aliases => "-c", :desc => "Content of the variable", :required => true
    def add(shared_config)
      org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      Sem::API::EnvVars.add_to_shared_config(org_name,
                                             shared_config_name,
                                             :name => options[:name],
                                             :content => options[:content])

      puts "Added #{options[:name]} to #{org_name}/#{shared_config_name}"
    end

    desc "remove", "remove an environment variable from the shared configuration"
    def remove(shared_config, env_var)
      org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      Sem::API::EnvVars.remove_from_shared_config(org_name, shared_config_name, env_var)

      puts "Removed #{env_var} from #{org_name}/#{shared_config_name}"
    end
  end

  register "files", "manage files", Files
  register "env-vars", "manage environment variables", EnvVars
end
