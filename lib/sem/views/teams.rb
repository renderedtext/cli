class Sem::Views::Teams < Sem::Views::Base
  class << self
    def list(teams)
      if teams.empty?
        puts "You don't have any teams on Semaphore."
        puts ""
        puts "Create your first team:"
        puts ""
        puts "  sem teams:create ORG_NAME/TEAM"
        puts ""

        return
      end

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

    def list_members(team, members)
      if members.empty?
        puts "You don't have any members in the team."
        puts ""
        puts "Add your first member:"
        puts ""
        puts "  sem teams:members:add #{team} USERNAME"
        puts ""

        return
      end

      header = ["NAME"]

      body = members.map do |user|
        [user[:id]]
      end

      print_table [header, *body]
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
