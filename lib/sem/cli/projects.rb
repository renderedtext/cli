class Sem::CLI::Projects < Dracula

  desc "list", "list projects"
  def list
    projects = Sem::API::Project.all

    if projects.size > 0
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

  class SharedConfigs < Dracula

    desc "list", "list shared configurations on a project"
    def list(project_name)
      project = Sem::API::Project.find!(project_name)
      shared_configs = project.shared_configs

      if shared_configs.size > 0
        Sem::Views::Projects.shared_config_list(project, shared_configs)
      else
        Sem::Views::Projects.attach_first_shared_configuration(project)
      end
    end

    desc "add", "attach a shared configuration to a project"
    def add(project_name, shared_config_name)
      project = Sem::API::Project.find!(project_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      project.add_shared_config(shared_config)

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
end
