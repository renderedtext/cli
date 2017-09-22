class Sem::CLI::Projects < Dracula

  desc "list", "list projects"
  def list
    Sem::Views::Projects.list(Sem::API::Project.all)
  end

  desc "info", "shows detailed information about a project"
  def info(project)
    prj = Sem::API::Project.find_by_srn!(project)

    Sem::Views::Projects.info(prj)
  end

  class SharedConfigs < Dracula
    desc "list", "list shared configurations on a project"
    def list(project)
      shared_configs = Sem::API::Project.find_by_srn!(project).shared_configs

      Sem::Views::SharedConfigs.list(project_instance.shared_configs)
    end

    desc "add", "attach a shared configuration to a project"
    def add(project, shared_config)
      project_org_name, project_name = Sem::SRN.parse_project(project)
      shared_config_org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      if project_org_name != shared_config_org_name
        abort Sem::Views::Projects.org_names_not_matching("project", "shared configuration", project, shared_config)
      end

      Sem::API::SharedConfigs.add_to_project(project_org_name, project_name, shared_config_name)

      puts "Shared Configuration #{project_org_name}/#{shared_config_name} added to the project."
    end

    desc "remove", "removes a shared configuration from the project"
    def remove(project, shared_config)
      project_org_name, project_name = Sem::SRN.parse_project(project)
      shared_config_org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      if project_org_name != shared_config_org_name
        abort Sem::Views::Projects.org_names_not_matching("project", "shared configuration", project, shared_config)
      end

      Sem::API::SharedConfigs.remove_from_project(project_org_name, project_name, shared_config_name)

      puts "Shared Configuration #{project_org_name}/#{shared_config_name} removed from the project."
    end
  end

  register "shared-configs", "manage shared configurations", SharedConfigs

end
