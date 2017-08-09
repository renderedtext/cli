class Sem::CLI::Teams < Sem::ThorExt::SubcommandThor
  namespace "teams"

  desc "list", "list information about a team"
  def list
    teams = Sem::API::Teams.list

    print_table(teams_table(teams))
  end

  desc "info [NAME]", "show information about a team"
  def info(name)
    team = Sem::API::Teams.info(name)

    print_table(team_table(team))
  end

  desc "create [NAME]", "create a new team"
  method_option :permission, :default => "read",
                             :aliases => "-p",
                             :desc => "Permission level of the team in the organization"
  def create(name)
    org_name, team_name = name.split("/")

    team = Sem::API::Teams.create(org_name,
                                  :name => team_name,
                                  :permission => options["permission"])

    print_table(team_table(team))
  end

  desc "update [NAME]", "update a team"
  method_option :permission, :aliases => "-p", :desc => "Permission level of the team in the organization"
  method_option :name, :aliases => "-n", :desc => "Name of the team"
  def update(_name)
    new_name = options["name"]
    new_permission = options["permission"]

    info = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", new_name],
      ["Permission", new_permission],
      ["Members", "4 members"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(info)
  end

  desc "delete [NAME]", "removes a team from your organization"
  def delete(name)
    Sem::API::Teams.delete(name)

    puts "Deleted team #{name}"
  end

  private

  def teams_table(teams)
    header = ["ID", "NAME", "PERMISSION", "MEMBERS"]

    body = teams.map do |team|
      [team[:id], team[:name], team[:permission], "#{team[:members]} members"]
    end

    [header, *body]
  end

  def team_table(team)
    [
      ["ID", team[:id]],
      ["Name", team[:name]],
      ["Permission", team[:permission]],
      ["Members", "#{team[:members]} members"],
      ["Created", team[:created_at]],
      ["Updated", team[:updated_at]]
    ]
  end

end
