class Sem::CLI::SharedConfigs < Dracula

  desc "list", "list shared cofigurations"
  long_desc <<-DESC
Examples:

    $ sem shared-configs:list
    ID                                    NAME                 CONFIG FILES  ENV VARS
    99c7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/tokens             1         0
    1133ed43-ac8a-487e-b488-c38bc757a044  renderedtext/secrets            0         1
DESC
  def list
    shared_configs = Sem::API::SharedConfig.all

    if !shared_configs.empty?
      Sem::Views::SharedConfigs.list(shared_configs)
    else
      Sem::Views::SharedConfigs.setup_first_shared_config
    end
  end

  desc "info", "show information about a shared configuration"
  long_desc <<-DESC
Examples:

    $ sem shared-configs:info renderedtext/secrets
    ID                     99c7ed43-ac8a-487e-b488-c38bc757a034
    Name                   renderedtext/secrets
    Config Files           1
    Environment Variables  0
    Created                2017-08-01 13:14:40 +0200
    Updated                2017-08-02 13:14:40 +0200
DESC
  def info(shared_config_name)
    shared_config = Sem::API::SharedConfig.find!(shared_config_name)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "create", "create a new shared configuration"
  long_desc <<-DESC
Examples:

    $ sem shared-configs:create renderedtext/secrets
    ID                     99c7ed43-ac8a-487e-b488-c38bc757a034
    Name                   renderedtext/secrets
    Config Files           1
    Environment Variables  0
    Created                2017-08-01 13:14:40 +0200
    Updated                2017-08-02 13:14:40 +0200
DESC
  def create(shared_config_name)
    shared_config = Sem::API::SharedConfig.create!(shared_config_name)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "rename", "rename a shared configuration"
  long_desc <<-DESC
Examples:

    $ sem shared-configs:create renderedtext/secrets renderedtext/psst
    ID                     99c7ed43-ac8a-487e-b488-c38bc757a034
    Name                   renderedtext/psst
    Config Files           1
    Environment Variables  0
    Created                2017-08-01 13:14:40 +0200
    Updated                2017-08-02 13:14:40 +0200
DESC
  def rename(old_shared_config_name, new_shared_config_name)
    old_org_name, _old_name = Sem::SRN.parse_shared_config(old_shared_config_name)
    new_org_name, new_name = Sem::SRN.parse_shared_config(new_shared_config_name)

    abort "Shared Configuration can't change its organization" unless new_org_name == old_org_name

    shared_config = Sem::API::SharedConfig.find!(old_shared_config_name)
    shared_config = shared_config.update!(:name => new_name)

    Sem::Views::SharedConfigs.info(shared_config)
  end

  desc "delete", "removes a shared configuration from your organization"
  long_desc <<-DESC
Examples:

    $ sem shared-configs:delete renderedtext/secrets
    Deleted shared configuration renderedtext/secrets.
DESC
  def delete(shared_config_name)
    shared_config = Sem::API::SharedConfig.find!(shared_config_name)
    shared_config.delete!

    puts "Deleted shared configuration #{shared_config_name}."
  end

  class Files < Dracula

    desc "list", "list files in a shared configuration"
    long_desc <<-DESC
Examples:

    $ sem shared-configs:files:list renderedtext/secrets
    ID                                    PATH                      ENCRYPTED?
    77c7ed43-ac8a-487e-b488-c38bc757a034  /home/runner/a            true
    11c7ed43-bc8a-a87e-ba88-a38ba757a034  /home/runner/secrets.txt  true
DESC
    def list(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)
      files = shared_config.files

      if !files.empty?
        Sem::Views::Files.list(files)
      else
        Sem::Views::SharedConfigs.add_first_file(shared_config)
      end
    end

    desc "add", "add a file to the shared configuration"
    option "path-on-semaphore", :aliases => "p", :desc => "Path of the file in builds relative to /home/runner directory", :required => true
    option "local-path", :aliases => "l", :desc => "Location of the file on the local machine", :required => true
    long_desc <<-DESC
Examples:

    $ sem shared-configs:files:add renderedtext/secrets --local-path /tmp/secrets.json --path-on-semaphore secrets.json
    Added /home/runner/secrets.txt to renderedtext/secrets.
DESC
    def add(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      local_path = options["local-path"]

      abort "File #{local_path} not found" unless File.exist?(local_path)

      path = options["path-on-semaphore"]
      content = File.read(local_path)

      shared_config.add_config_file(:path => path, :content => content, :encrypted => true)

      puts "Added /home/runner/#{path} to #{shared_config_name}."
    end

    desc "remove", "remove a file from the shared configuration"
    option :path, :aliases => "p", :desc => "Path of the file in builds relative to /home/runner directory", :required => true
    long_desc <<-DESC
Examples:

    $ sem shared-configs:files:remove renderedtext/secrets --path secrets.json
    Removed /home/runner/secrets.txt from renderedtext/secrets.
DESC
    def remove(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      shared_config.remove_config_file(options[:path])

      puts "Removed /home/runner/#{options[:path]} from #{shared_config_name}."
    end

  end

  class EnvVars < Dracula

    desc "list", "list environment variables in the shared configuration"
    long_desc <<-DESC
Examples:

    $ sem shared-configs:files:list renderedtext/secrets
    ID                                    NAME    ENCRYPTED?  CONTENT
    9997ed43-ac8a-487e-b488-c38bc757a034  SECRET  true        aaa
    1117ed43-tc8a-387e-6488-838bc757a034  TOKEN   true        *encrypted*
DESC
    def list(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)
      env_vars = shared_config.env_vars

      if !env_vars.empty?
        Sem::Views::EnvVars.list(env_vars)
      else
        Sem::Views::SharedConfigs.add_first_env_var(shared_config)
      end
    end

    desc "add", "add an environment variable to the shared configuration"
    option :name, :aliases => "n", :desc => "Name of the variable", :required => true
    option :content, :aliases => "c", :desc => "Content of the variable", :required => true
    long_desc <<-DESC
Examples:

    $ sem shared-configs:env-vars:add renderedtext/secrets --name TOKEN --content "s3cr3t"
    Added TOKEN to renderedtext/secrets.
DESC
    def add(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      shared_config.add_env_var(:name => options[:name], :content => options[:content], :encrypted => true)

      puts "Added #{options[:name]} to #{shared_config_name}."
    end

    desc "remove", "remove an environment variable from the shared configuration"
    option :name, :aliases => "n", :desc => "Name of the variable", :required => true
    long_desc <<-DESC
Examples:

    $ sem shared-configs:env-vars:remove renderedtext/secrets --name TOKEN
    Removed TOKEN from renderedtext/secrets.
DESC
    def remove(shared_config_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)
      name = options[:name]

      shared_config.remove_env_var(name)

      puts "Removed #{name} from #{shared_config_name}"
    end

  end

  register "files", "manage files", Files
  register "env-vars", "manage environment variables", EnvVars
end
