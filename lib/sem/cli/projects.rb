class Sem::CLI::Projects < Sem::ThorExt::SubcommandThor
  namespace "projects"

  def self.instances_table(projects)
    header = ["ID", "NAME"]

    body = projects.map do |project|
      [project[:id], project[:name]]
    end

    [header, *body]
  end

  desc "list", "list projects"
  def list
    orgs = [
      ["ID", "NAME", "VISIBILITY"],
      ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext/cli", "public"],
      ["fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", "tb-render/api", "private"]
    ]

    print_table(orgs)
  end

  desc "info", "shows detailed information about a project"
  def info(_project)
    project = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", "renderedtext/cli"],
      ["Visibility", "public"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(project)
  end
end
