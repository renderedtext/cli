class Sem::CLI::Projects < Dracula

  desc "list", "list all your projects"
  long_desc <<-DESC
Examples:

    $ sem projects:list
    NAME
    ID                                    NAME
    99c7ed43-ac8a-487e-b488-c38bc757a034  rt/cli
    99c7ed43-ac8a-487e-b488-c38bc757a034  rt/api
DESC
  def list
    projects = Sem::API::Project.all

    if !projects.empty?
      Sem::Views::Projects.list(projects)
    else
      Sem::Views::Projects.setup_first_project
    end
  end

  desc "info", "shows detailed information about a project"
  long_desc <<-DESC
Examples:

    $ sem projects:info renderedtext/cli
    ID       99c7ed43-ac8a-487e-b488-c38bc757a034
    Name     renderedtext/cli
    Created  2017-08-01 13:14:40 +0200
    Updated  2017-08-02 13:14:40 +0200
DESC
  def info(project_name)
    project = Sem::API::Project.find!(project_name)

    Sem::Views::Projects.info(project)
  end

  desc "create", "create a project"
  option :url, :aliases => "-u", :desc => "Git url to the repository", :required => true
  long_desc <<-DESC
Examples:

    $ sem projects:create renderedtext/cli --url git@github.com:renderedtext/cli.git
    ID       99c7ed43-ac8a-487e-b488-c38bc757a034
    Name     renderedtext/cli
    Created  2017-08-01 13:14:40 +0200
    Updated  2017-08-02 13:14:40 +0200

    $ sem projects:create renderedtext/api --url https://github.com/renderedtext/api
    ID       99c7ed43-ac8a-487e-b488-c38bc757a034
    Name     renderedtext/api
    Created  2017-08-01 13:14:40 +0200
    Updated  2017-08-02 13:14:40 +0200

    $ sem projects:create renderedtext/api-tests --url https://github.com/renderedtext/api
    ID       99c7ed43-ac8a-487e-b488-c38bc757a034
    Name     renderedtext/api-tests
    Created  2017-08-01 13:14:40 +0200
    Updated  2017-08-02 13:14:40 +0200
DESC
  def create(project_name)
    url = Sem::Helpers::GitUrl.new(options[:url])

    abort "Git URL #{options[:url]} is invalid." unless url.valid?

    args = {
      :repo_provider => url.repo_provider,
      :repo_owner => url.repo_owner,
      :repo_name => url.repo_name
    }

    project = Sem::API::Project.create!(project_name, args)

    Sem::Views::Projects.info(project)
  end

  class Files < Dracula

    desc "list", "list configuration files for a project"
    long_desc <<-DESC
Examples:

    $ sem projects:files:list renderedtext/cli
    ID                                    PATH              ENCRYPTED?
    77c7ed43-ac8a-487e-b488-c38bc757a034  /etc/a            true
    11c7ed43-bc8a-a87e-ba88-a38ba757a034  /var/secrets.txt  true
DESC
    def list(project_name)
      project = Sem::API::Project.find!(project_name)

      Sem::Views::Files.list(project.config_files)
    end

  end

  class EnvVars < Dracula

    desc "list", "list environment variables on project"
    long_desc <<-DESC
Examples:

    $ sem projects:env-vars:list renderedtext/cli
    ID                                    NAME    ENCRYPTED?  CONTENT
    9997ed43-ac8a-487e-b488-c38bc757a034  SECRET  false       aaa
    1117ed43-tc8a-387e-6488-838bc757a034  TOKEN   true        *encrypted*
DESC
    def list(project_name)
      project = Sem::API::Project.find!(project_name)

      Sem::Views::EnvVars.list(project.env_vars)
    end

  end

  class Secrets < Dracula

    desc "list", "list secrets on a project"
    long_desc <<-DESC
Examples:

    $ sem projects:secrets:list renderedtext/cli
    ID                                    NAME                 CONFIG FILES  ENV VARS
    99c7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/tokens             1         0
    99c7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/secrets            0         1
DESC
    def list(project_name)
      project = Sem::API::Project.find!(project_name)
      secrets = project.secrets

      if !secrets.empty?
        Sem::Views::Secrets.list(secrets)
      else
        Sem::Views::Projects.attach_first_secret(project)
      end
    end

    desc "add", "attach a secret to a project"
    long_desc <<-DESC
Examples:

    $ sem projects:secrets:add renderedtext/cli renderedtext/secrets
    Secret renderedtext/secrets added to the project.
DESC
    def add(project_name, secret_name)
      project = Sem::API::Project.find!(project_name)
      secret = Sem::API::Secret.find!(secret_name)

      project.add_secret(secret)

      puts "Secret #{secret_name} added to the project."
    end

    desc "remove", "removes a secret from the project"
    long_desc <<-DESC
Examples:

    $ sem projects:secrets:remove renderedtext/cli renderedtext/secrets
    Secret renderedtext/secrets removed from the project.
DESC
    def remove(project_name, secret_name)
      project = Sem::API::Project.find!(project_name)
      secret = Sem::API::Secret.find!(secret_name)

      project.remove_secret(secret)

      puts "Secret #{secret_name} removed from the project."
    end

  end

  register "secrets", "manage secrets", Secrets
  register "files", "manage projects' config files", Files
  register "env-vars", "manage projects' environment variables", EnvVars
end
