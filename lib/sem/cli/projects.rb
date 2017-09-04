class Sem::CLI::Projects < Dracula

  desc "list", "list projects"
  def list
    projects = Sem::API::Project.all

    if !projects.empty?
      Sem::Views::Projects.list(projects)
    else
      Sem::Views::Projects.setup_first_project
    end
  end

  desc "info", "shows detailed information about a project"
  def info(project_name)
    project = Sem::API::Project.find!(project_name)

    Sem::Views::Projects.info(project)
  end

  desc "create", "create a project"
  option :url, :aliases => "-u", :desc => "Git url to the repository"
  def create(project)
    org_name, project_name = Sem::SRN.parse_project(project)
    repo_provider, repo_owner, repo_name = Sem::Helpers::Git.parse_url(options[:url])

    project = Sem::API::Projects.create(org_name,
                                        :name => project_name,
                                        :repo_provider => repo_provider,
                                        :repo_owner => repo_owner,
                                        :repo_name => repo_name)

    Sem::Views::Projects.create(project)
  rescue Sem::Helpers::Git::InvalidGitUrl
    abort "Git URL #{options[:url]} is invalid."
  end

  class Files < Dracula

    desc "list", "list configuration files on project"
    def list(project_name)
      project = Sem::API::Project.find!(project_name)

      Sem::Views::Files.list(project.config_files)
    end

  end

  class EnvVars < Dracula

    desc "list", "list environment variables on project"
    def list(project_name)
      project = Sem::API::Project.find!(project_name)

      Sem::Views::EnvVars.list(project.env_vars)
    end

  end

  class SharedConfigs < Dracula

    desc "list", "list shared configurations on a project"
    def list(project_name)
      project = Sem::API::Project.find!(project_name)
      shared_configs = project.shared_configs

      if !shared_configs.empty?
        Sem::Views::SharedConfigs.list(shared_configs)
      else
        Sem::Views::Projects.attach_first_shared_config(project)
      end
    end

    desc "add", "attach a shared configuration to a project"
    def add(project_name, shared_config_name)
      project = Sem::API::Project.find!(project_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      project.add_shared_config(shared_config)

      shared_config.env_vars.each { |var| project.add_env_var(var) }
      shared_config.files.each { |file| project.add_config_file(file) }

      puts "Shared Configuration #{shared_config_name} added to the project."
    end

    desc "remove", "removes a shared configuration from the project"
    def remove(project_name, shared_config_name)
      project = Sem::API::Project.find!(project_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      project.remove_shared_config(shared_config)

      puts "Shared Configuration #{shared_config_name} removed from the project."
    end

  end

  register "shared-configs", "manage shared configurations", SharedConfigs
  register "files", "manage projects' config files", Files
  register "env-vars", "manage projects' environment variables", EnvVars
end
