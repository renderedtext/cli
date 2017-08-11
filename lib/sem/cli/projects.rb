class Sem::CLI::Projects < Sem::ThorExt::SubcommandThor
  namespace "projects"

  def self.instances_table(projects)
    header = ["ID", "NAME"]

    body = projects.map do |project|
      [project[:id], project[:name]]
    end

    [header, *body]
  end
end
