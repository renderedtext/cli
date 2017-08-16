class Sem::CLI::Projects < Dracula

  desc "list", "list projects"
  def list
    projects = Sem::API::Projects.list

    Sem::Views::Projects.list(projects)
  end

  desc "info", "shows detailed information about a project"
  def info(project_path)
    project = Sem::API::Projects.info(project_path)

    Sem::Views::Projects.info(project)
  end

end
