class Sem::Views::Teams < Sem::Views::Base
  def self.create_first_team
    puts "You don't have any teams on Semaphore."
    puts ""
    puts "Create your first team:"
    puts ""
    puts "  sem teams:create ORG_NAME/TEAM"
    puts ""
  end

  def self.list(teams)
    header = ["ID", "NAME", "PERMISSION", "MEMBERS"]

    body = teams.map do |team|
      [team.id, team.full_name, team.permission, "#{team.users.count} members"]
    end

    print_table [header, *body]
  end

  def self.info(team)
    print_table [
      ["ID", team.id],
      ["Name", team.full_name],
      ["Permission", team.permission],
      ["Members", "#{team.users.count} members"],
      ["Created", team.created_at],
      ["Updated", team.updated_at]
    ]
  end

  def self.add_first_team_member(team)
    puts "You don't have any members in the team."
    puts ""
    puts "Add your first member:"
    puts ""
    puts "  sem teams:members:add #{team.full_name} USERNAME"
    puts ""
  end

  def self.add_first_project(team)
    puts "You don't have any projects in this team."
    puts ""
    puts "Add your first project:"
    puts ""
    puts "  sem teams:projects:add #{team.full_name} PROJECT_NAME"
    puts ""
  end

  def self.add_first_secrets(team)
    puts "You don't have any secrets in this team."
    puts ""
    puts "Add your first secrets:"
    puts ""
    puts "  sem teams:secrets:add #{team.full_name} SECRET_NAME"
    puts ""
  end
end
