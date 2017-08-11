class Sem::CLI::Teams < Sem::ThorExt::SubcommandThor
  namespace "teams"

  def self.instances_table(teams)
    header = ["ID", "NAME", "PERMISSION", "MEMBERS"]

    body = teams.map do |team|
      [team[:id], team[:name], team[:permission], "#{team[:members]} members"]
    end

    [header, *body]
  end

  def self.instance_table(team)
    [
      ["ID", team[:id]],
      ["Name", team[:name]],
      ["Permission", team[:permission]],
      ["Members", "#{team[:members]} members"],
      ["Created", team[:created_at]],
      ["Updated", team[:updated_at]]
    ]
  end

  desc "list", "list teams"
  def list
    teams = Sem::API::Teams.list

    print_table(Sem::CLI::Teams.instances_table(teams))
  end

  desc "info", "show information about a team"
  def info(name)
    team = Sem::API::Teams.info(name)

    print_table(Sem::CLI::Teams.instance_table(team))
  end

  desc "create", "create a new team"
  method_option :permission, :default => "read",
                             :aliases => "-p",
                             :desc => "Permission level of the team in the organization"
  def create(name)
    org_name, team_name = name.split("/")

    team = Sem::API::Teams.create(org_name,
                                  :name => team_name,
                                  :permission => options["permission"])

    print_table(Sem::CLI::Teams.instance_table(team))
  end

  desc "rename", "change the name of the team"
  def rename(_old_name, new_name)
    info = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", new_name],
      ["Permission", "admin"],
      ["Members", "4 members"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(info)
  end

  desc "set-permission", "set the permission level of the team"
  def set_permission(team_name, permission)
    info = [
      ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
      ["Name", team_name],
      ["Permission", permission],
      ["Members", "4 members"],
      ["Created", "2017-08-01 13:14:40 +0200"],
      ["Updated", "2017-08-02 13:14:40 +0200"]
    ]

    print_table(info)
  end

  desc "delete", "removes a team from your organization"
  def delete(name)
    Sem::API::Teams.delete(name)

    puts "Deleted team #{name}"
  end

  class Members < Sem::ThorExt::SubcommandThor
    namespace "teams:members"

    desc "list", "lists members of the team"
    def list(team_name)
      members = Sem::API::Users.list_for_team(team_name)

      print_table(Sem::CLI::Users.instances_table(members))
    end

    desc "add", "add a user to the team"
    def add(team_name, username)
      Sem::API::Users.add_to_team(team_name, username)

      puts "User #{username} added to the team."
    end

    desc "remove", "removes a user from the team"
    def remove(team_name, username)
      Sem::API::Users.remove_from_team(team_name, username)

      puts "User #{username} removed from the team."
    end
  end

  class Projects < Sem::ThorExt::SubcommandThor
    namespace "teams:projects"

    desc "list", "lists projects in a team"
    def list(team_name)
      projects = Sem::API::Projects.list_for_team(team_name)

      print_table(Sem::CLI::Projects.instances_table(projects))
    end

    desc "add", "add a project to a team"
    def add(team_name, project_name)
      Sem::API::Projects.add_to_team(team_name, project_name)

      puts "Project #{project_name} added to the team."
    end

    desc "remove", "removes a project from the team"
    def remove(team_name, project_name)
      Sem::API::Projects.remove_from_team(team_name, project_name)

      puts "Project #{project_name} removed from the team."
    end
  end

  class Configs < Sem::ThorExt::SubcommandThor
    namespace "teams:configs"

    desc "list", "list shared confgiurations in a team"
    def list(team_name)
      configs = Sem::API::Configs.list_for_team(team_name)

      print_table(Sem::CLI::Configs.instances_table(configs))
    end

    desc "add", "add a shared configuration to a team"
    def add(team_name, shared_config_name)
      Sem::API::Configs.add_to_team(team_name, shared_config_name)

      puts "Shared Configuration #{shared_config_name} added to the team."
    end

    desc "remove", "removes a project from the team"
    def remove(team_name, shared_config_name)
      Sem::API::Configs.remove_from_team(team_name, shared_config_name)

      puts "Shared Configuration #{shared_config_name} removed from the team."
    end
  end

  desc "members", "manage team members", :hide => true
  subcommand "members", Members

  desc "projects", "manage team members", :hide => true
  subcommand "projects", Projects

  desc "configs", "manage shared configurations", :hide => true
  subcommand "configs", Configs
end
