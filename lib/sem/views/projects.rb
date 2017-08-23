class Sem::Views::Projects < Sem::Views::Base
  class << self
    def list(projects)
      header = ["ID", "NAME"]

      body = projects.map do |project|
        [project[:id], name(project)]
      end

      print_table([header, *body])
    end

    def info(project)
      print_table [
        ["ID", project[:id]],
        ["Name", name(project)],
        ["Created", project[:created_at]],
        ["Updated", project[:updated_at]]
      ]
    end

    private

    def name(project)
      return unless project[:org] && project[:name]

      "#{project[:org]}/#{project[:name]}"
    end
  end
end
