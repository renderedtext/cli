class Sem::CLI::Teams < Dracula

  desc "list", "list teams"
  def list
    teams = Sem::API::Teams.list

    Sem::Views::Teams.list(teams)
  end

  desc "info", "show information about a team"
  def info(path)
    org_name, team_name = path.split("/")

    team = Sem::API::Teams.info(org_name, team_name)

    Sem::Views::Teams.info(team)
  end

  desc "create", "create a new team"
  option :permission, :default => "read",
                      :aliases => "-p",
                      :desc => "Permission level of the team in the organization"
  def create(path)
    org_name, team_name = path.split("/")

    team = Sem::API::Teams.create(org_name,
                                  :name => team_name,
                                  :permission => options[:permission])

    Sem::Views::Teams.info(team)
  end

  desc "rename", "change the name of the team"
  def rename(old_path, new_path)
    org_name, old_name = old_path.split("/")
    _, new_name = new_path.split("/")

    team = Sem::API::Teams.update(org_name, old_name, :name => new_name)

    Sem::Views::Teams.info(team)
  end

  desc "set-permission", "set the permission level of the team"
  def set_permission(path, permission)
    org_name, team_name = path.split("/")

    team = Sem::API::Teams.update(org_name, team_name, :permission => permission)

    Sem::Views::Teams.info(team)
  end

  desc "delete", "removes a team from your organization"
  def delete(path)
    org_name, team_name = path.split("/")

    Sem::API::Teams.delete(org_name, team_name)

    puts "Deleted team #{org_name}/#{team_name}"
  end

  class Members < Dracula
    desc "list", "lists members of the team"
    def list(team_path)
      org_name, team_name = team_path.split("/")

      members = Sem::API::Users.list_for_team(org_name, team_name)

      Sem::Views::Users.list(members)
    end

    desc "add", "add a user to the team"
    def add(team_path, username)
      org_name, team_name = team_path.split("/")

      Sem::API::Users.add_to_team(org_name, team_name, username)

      puts "User #{username} added to the team."
    end

    desc "remove", "removes a user from the team"
    def remove(team_path, username)
      org_name, team_name = team_path.split("/")

      Sem::API::Users.remove_from_team(org_name, team_name, username)

      puts "User #{username} removed from the team."
    end
  end

  class Projects < Dracula
    desc "list", "lists projects in a team"
    def list(team_path)
      org_name, team_name = team_path.split("/")

      projects = Sem::API::Projects.list_for_team(org_name, team_name)

      Sem::Views::Projects.list(projects)
    end

    desc "add", "add a project to a team"
    def add(team_path, project_path)
      org_name, team_name = team_path.split("/")
      _, project_name = project_path.split("/")

      Sem::API::Projects.add_to_team(org_name, team_name, project_name)

      puts "Project #{org_name}/#{project_name} added to the team."
    end

    desc "remove", "removes a project from the team"
    def remove(team_path, project_path)
      org_name, team_name = team_path.split("/")
      _, project_name = project_path.split("/")

      Sem::API::Projects.remove_from_team(org_name, team_name, project_name)

      puts "Project #{org_name}/#{project_name} removed from the team."
    end
  end

  class SharedConfigs < Dracula
    desc "list", "list shared configurations in a team"
    def list(team_path)
      org_name, team_name = team_path.split("/")

      configs = Sem::API::SharedConfigs.list_for_team(org_name, team_name)

      Sem::Views::SharedConfigs.list(configs)
    end

    desc "add", "add a shared configuration to a team"
    def add(team_path, shared_config_path)
      org_name, team_name = team_path.split("/")
      _, shared_config_name = shared_config_path.split("/")

      Sem::API::SharedConfigs.add_to_team(org_name, team_name, shared_config_name)

      puts "Shared Configuration #{org_name}/#{shared_config_name} added to the team."
    end

    desc "remove", "removes a project from the team"
    def remove(team_path, shared_config_path)
      org_name, team_name = team_path.split("/")
      _, shared_config_name = shared_config_path.split("/")

      Sem::API::SharedConfigs.remove_from_team(org_name, team_name, shared_config_name)

      puts "Shared Configuration #{org_name}/#{shared_config_name} removed from the team."
    end
  end

  register "members", "manage team members", Members
  register "projects", "manage team members", Projects
  register "shared-configs", "manage shared configurations", SharedConfigs
end
