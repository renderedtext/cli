class Sem::Views::Projects < Sem::Views::Base

  def self.list(projects)
    header = ["ID", "NAME"]

    body = projects.map do |project|
      [project[:id], project[:name]]
    end

    print_table([header, *body])
  end

  def self.info(project)

  end

end
