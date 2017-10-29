class Sem::CLI::Secrets < Dracula

  desc "list", "list secrets"
  long_desc <<-DESC
Examples:

    $ sem secrets:list
    ID                                    NAME                 CONFIG FILES  ENV VARS
    99c7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/tokens             1         0
    1133ed43-ac8a-487e-b488-c38bc757a044  renderedtext/secrets            0         1
DESC
  def list
    secrets = Sem::API::Secrets.all

    if !secrets.empty?
      Sem::Views::Secrets.list(secrets)
    else
      Sem::Views::Secrets.setup_first_secret
    end
  end

  desc "info", "show information about secrets"
  long_desc <<-DESC
Examples:

    $ sem secrets:info renderedtext/tokens
    ID                     99c7ed43-ac8a-487e-b488-c38bc757a034
    Name                   renderedtext/tokens
    Config Files           1
    Environment Variables  0
    Created                2017-08-01 13:14:40 +0200
    Updated                2017-08-02 13:14:40 +0200
DESC
  def info(secret_name)
    secret = Sem::API::Secret.find!(secret_name)

    Sem::Views::Secrets.info(secrets)
  end

  desc "create", "create new secrets"
  long_desc <<-DESC
Examples:

    $ sem secrets:create renderedtext/tokens
    ID                     99c7ed43-ac8a-487e-b488-c38bc757a034
    Name                   renderedtext/tokens
    Config Files           1
    Environment Variables  0
    Created                2017-08-01 13:14:40 +0200
    Updated                2017-08-02 13:14:40 +0200
DESC
  def create(secrets_name)
    secret = Sem::API::SharedConfig.create!(secret_name)

    Sem::Views::Secrets.info(secret)
  end

  desc "rename", "rename secrets"
  long_desc <<-DESC
Examples:

    $ sem secrets:create renderedtext/tokens renderedtext/psst
    ID                     99c7ed43-ac8a-487e-b488-c38bc757a034
    Name                   renderedtext/psst
    Config Files           1
    Environment Variables  0
    Created                2017-08-01 13:14:40 +0200
    Updated                2017-08-02 13:14:40 +0200
DESC
  def rename(old_secrets_name, new_secrets_name)
    old_org_name, _old_name = Sem::SRN.parse_secrets(old_secrets_name)
    new_org_name, new_name = Sem::SRN.parse_secrets(new_secrets_name)

    abort "Secrets can't change their organization" unless new_org_name == old_org_name

    secret = Sem::API::Secret.find!(old_secrets_name)
    secret = secret.update!(:name => new_name)

    Sem::Views::Secrets.info(secret)
  end

  desc "delete", "removes secrets from your organization"
  long_desc <<-DESC
Examples:

    $ sem secrets:delete renderedtext/tokens
    Deleted renderedtext/tokens.
DESC
  def delete(secrets_name)
    secret = Sem::API::Secret.find!(secrets_name)
    secret.delete!

    puts "Deleted #{shared_config_name}."
  end

  class Files < Dracula

    desc "list", "list files in secrets"
    long_desc <<-DESC
Examples:

    $ sem secrets:files:list renderedtext/tokens
    ID                                    PATH                      ENCRYPTED?
    77c7ed43-ac8a-487e-b488-c38bc757a034  /home/runner/a            true
    11c7ed43-bc8a-a87e-ba88-a38ba757a034  /home/runner/secrets.txt  true
DESC
    def list(secret_name)
      secret = Sem::API::Secret.find!(secret_name)
      files = secret.files

      if !files.empty?
        Sem::Views::Files.list(files)
      else
        Sem::Views::Secrets.add_first_file(secret)
      end
    end

    desc "add", "add a file to secrets"
    option "path-on-semaphore", :aliases => "p", :desc => "Path of the file in builds relative to /home/runner directory", :required => true
    option "local-path", :aliases => "l", :desc => "Location of the file on the local machine", :required => true
    long_desc <<-DESC
Examples:

    $ sem secrets:files:add renderedtext/tokens --local-path /tmp/secrets.json --path-on-semaphore secrets.json
    Added /home/runner/secrets.txt to renderedtext/secrets.
DESC
    def add(secrets_name)
      secret = Sem::API::Secret.find!(secrets_name)

      local_path = options["local-path"]

      abort "File #{local_path} not found" unless File.exist?(local_path)

      path = options["path-on-semaphore"]
      content = File.read(local_path)

      secret.add_config_file(:path => path, :content => content, :encrypted => true)

      puts "Added /home/runner/#{path} to #{secrets_name}."
    end

    desc "remove", "remove a file from secrets"
    option :path, :aliases => "p", :desc => "Path of the file in builds relative to /home/runner directory", :required => true
    long_desc <<-DESC
Examples:

    $ sem secrets:files:remove renderedtext/secrets --path secrets.json
    Removed /home/runner/secrets.txt from renderedtext/secrets.
DESC
    def remove(secrets_name)
      secret = Sem::API::Secret.find!(secrets_name)

      secret.remove_config_file(options[:path])

      puts "Removed /home/runner/#{options[:path]} from #{secrets_name}."
    end

  end

  class EnvVars < Dracula

    desc "list", "list environment variables in secrets"
    long_desc <<-DESC
Examples:

    $ sem secrets:files:list renderedtext/tokens
    ID                                    NAME    ENCRYPTED?  CONTENT
    9997ed43-ac8a-487e-b488-c38bc757a034  SECRET  true        aaa
    1117ed43-tc8a-387e-6488-838bc757a034  TOKEN   true        *encrypted*
DESC
    def list(secret_name)
      secret = Sem::API::Secret.find!(secret_name)
      env_vars = secret.env_vars

      if !env_vars.empty?
        Sem::Views::EnvVars.list(env_vars)
      else
        Sem::Views::Secrets.add_first_env_var(secret)
      end
    end

    desc "add", "add an environment variable to secrets"
    option :name, :aliases => "n", :desc => "Name of the variable", :required => true
    option :content, :aliases => "c", :desc => "Content of the variable", :required => true
    long_desc <<-DESC
Examples:

    $ sem secrets:env-vars:add renderedtext/secrets --name TOKEN --content "s3cr3t"
    Added TOKEN to renderedtext/secrets.
DESC
    def add(secret_name)
      secret = Sem::API::Secret.find!(secret_name)

      secret.add_env_var(:name => options[:name], :content => options[:content], :encrypted => true)

      puts "Added #{options[:name]} to #{secret_name}."
    end

    desc "remove", "remove an environment variable from secrets"
    option :name, :aliases => "n", :desc => "Name of the variable", :required => true
    long_desc <<-DESC
Examples:

    $ sem secrets:env-vars:remove renderedtext/secrets --name TOKEN
    Removed TOKEN from renderedtext/secrets.
DESC
    def remove(secrets_name)
      secret = Sem::API::Secret.find!(secrets_name)
      name = options[:name]

      secret.remove_env_var(name)

      puts "Removed #{name} from #{secrets_name}"
    end

  end

  register "files", "manage files", Files
  register "env-vars", "manage environment variables", EnvVars
end
