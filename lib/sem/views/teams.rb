class Sem::Views::Teams < Sem::Views::Base
  class << self
    def list(teams)
      header = ["ID", "NAME", "PERMISSION", "MEMBERS"]

      body = teams.map do |team|
        [team[:id], "#{team[:org]}/#{team[:name]}", permission(team), "#{team[:members]} members"]
      end

      print_table [header, *body]
    end

    def info(team)
      print_table [
        ["ID", team[:id]],
        ["Name", name(team)],
        ["Permission", permission(team)],
        ["Members", members(team)],
        ["Created", team[:created_at]],
        ["Updated", team[:updated_at]]
      ]
    end

    private

    def name(team)
      return unless team[:org] && team[:name]

      "#{team[:org]}/#{team[:name]}"
    end

    def members(team)
      return unless team[:members]

      "#{team[:members]} members"
    end

    def permission(team)
      return "write" if team[:permission] == "edit"

      team[:permission]
    end
  end
end
