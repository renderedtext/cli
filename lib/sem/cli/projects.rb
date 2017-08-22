class Sem::CLI::Projects < Dracula

  desc "list", "list projects"
  def list
    projects = Sem::API::Projects.list

    Sem::Views::Projects.list(projects)
  end

  desc "info", "shows detailed information about a project"
  def info(srn)
    org_name, project_name = Sem::SRN.parse_project(srn)

    project = Sem::API::Projects.info(org_name, project_name).to_h

    Sem::Views::Projects.info(project)
  end

end
