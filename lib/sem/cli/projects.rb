class Sem::CLI::Projects < Dracula

  desc "list", "list projects"
  def list
    projects = Sem::API::Projects.list

    Sem::Views::Projects.list(projects)
  end

  desc "info", "shows detailed information about a project"
  def info(path)
    org_name, project_name = path.split("/")

    project = Sem::API::Projects.info(org_name, project_name)

    Sem::Views::Projects.info(project)
  end

end
