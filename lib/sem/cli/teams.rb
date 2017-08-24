class Sem::CLI::Teams < Dracula

  desc "list", "list teams"
  def list
    teams = Sem::API::Teams.list

    Sem::Views::Teams.list(teams)
  end

  desc "info", "show information about a team"
  def info(team)
    org_name, team_name = Sem::SRN.parse_team(team)

    team_instance = Sem::API::Teams.info(org_name, team_name).to_h

    Sem::Views::Teams.info(team_instance)
  end

  desc "create", "create a new team"
  option :permission, :default => "read",
                      :aliases => "-p",
                      :desc => "Permission level of the team in the organization"
  def create(team)
    org_name, team_name = Sem::SRN.parse_team(team)

    team_instance = Sem::API::Teams.create(org_name,
                                           :name => team_name,
                                           :permission => options[:permission])

    Sem::Views::Teams.info(team_instance)
  end

  desc "rename", "change the name of the team"
  def rename(old_team, new_team)
    old_org_name, old_name = Sem::SRN.parse_team(old_team)
    new_org_name, new_name = Sem::SRN.parse_team(new_team)

    raise Sem::Errors::OrgNamesNotMatching unless old_org_name == new_org_name

    team_instance = Sem::API::Teams.update(old_org_name, old_name, :name => new_name)

    Sem::Views::Teams.info(team_instance)
  end

  desc "set-permission", "set the permission level of the team"
  def set_permission(team, permission)
    unless ["read", "write", "admin"].include?(permission)
      raise Sem::Errors::InvalidParameter, "Permission \"#{permission}\" doesn't exist.\n" \
        "Choose one of the following: read, write, admin."
    end

    org_name, team_name = Sem::SRN.parse_team(team)

    team_instance = Sem::API::Teams.update(org_name, team_name, :permission => permission)

    Sem::Views::Teams.info(team_instance)
  end

  desc "delete", "removes a team from your organization"
  def delete(team)
    org_name, team_name = Sem::SRN.parse_team(team)

    Sem::API::Teams.delete(org_name, team_name)

    puts "Deleted team #{org_name}/#{team_name}"
  end

  class Members < Dracula
    desc "list", "lists members of the team"
    def list(team)
      org_name, team_name = Sem::SRN.parse_team(team)

      members = Sem::API::Users.list_for_team(org_name, team_name)

      Sem::Views::Teams.list_members(team, members)
    end

    desc "add", "add a user to the team"
    def add(team, user)
      org_name, team_name = Sem::SRN.parse_team(team)
      user_name = Sem::SRN.parse_user(user).first

      Sem::API::Users.add_to_team(org_name, team_name, user_name)

      puts "User #{user_name} added to the team."
    end

    desc "remove", "removes a user from the team"
    def remove(team, user)
      org_name, team_name = Sem::SRN.parse_team(team)
      user_name = Sem::SRN.parse_user(user).first

      Sem::API::Users.remove_from_team(org_name, team_name, user_name)

      puts "User #{user_name} removed from the team."
    end
  end

  class Projects < Dracula
    desc "list", "lists projects in a team"
    def list(team)
      org_name, team_name = Sem::SRN.parse_team(team)

      projects = Sem::API::Projects.list_for_team(org_name, team_name)

      Sem::Views::Projects.list(projects)
    end

    desc "add", "add a project to a team"
    def add(team, project)
      team_org_name, team_name = Sem::SRN.parse_team(team)
      project_org_name, project_name = Sem::SRN.parse_project(project)

      raise Sem::Errors::OrgNamesNotMatching unless team_org_name == project_org_name

      Sem::API::Projects.add_to_team(team_org_name, team_name, project_name)

      puts "Project #{team_org_name}/#{project_name} added to the team."
    end

    desc "remove", "removes a project from the team"
    def remove(team, project)
      team_org_name, team_name = Sem::SRN.parse_team(team)
      project_org_name, project_name = Sem::SRN.parse_project(project)

      raise Sem::Errors::OrgNamesNotMatching unless team_org_name == project_org_name

      Sem::API::Projects.remove_from_team(team_org_name, team_name, project_name)

      puts "Project #{team_org_name}/#{project_name} removed from the team."
    end
  end

  class SharedConfigs < Dracula
    desc "list", "list shared configurations in a team"
    def list(team)
      org_name, team_name = Sem::SRN.parse_team(team)

      configs = Sem::API::SharedConfigs.list_for_team(org_name, team_name)

      Sem::Views::SharedConfigs.list(configs)
    end

    desc "add", "add a shared configuration to a team"
    def add(team, shared_config)
      team_org_name, team_name = Sem::SRN.parse_team(team)
      shared_config_org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      raise Sem::Errors::OrgNamesNotMatching unless team_org_name == shared_config_org_name

      Sem::API::SharedConfigs.add_to_team(team_org_name, team_name, shared_config_name)

      puts "Shared Configuration #{team_org_name}/#{shared_config_name} added to the team."
    end

    desc "remove", "removes a project from the team"
    def remove(team, shared_config)
      team_org_name, team_name = Sem::SRN.parse_team(team)
      shared_config_org_name, shared_config_name = Sem::SRN.parse_shared_config(shared_config)

      raise Sem::Errors::OrgNamesNotMatching unless team_org_name == shared_config_org_name

      Sem::API::SharedConfigs.remove_from_team(team_org_name, team_name, shared_config_name)

      puts "Shared Configuration #{team_org_name}/#{shared_config_name} removed from the team."
    end
  end

  register "members", "manage team members", Members
  register "projects", "manage team members", Projects
  register "shared-configs", "manage shared configurations", SharedConfigs
end
