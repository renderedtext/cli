class Sem::CLI::Teams < Dracula

  desc "list", "list teams"
  def list
    teams = Sem::API::Team.all

    if !teams.empty?
      Sem::Views::Teams.list(teams)
    else
      Sem::Views::Teams.create_first_team
    end
  end

  desc "info", "show information about a team"
  def info(team_name)
    team = Sem::API::Team.find!(team_name)

    Sem::Views::Teams.info(team)
  end

  desc "create", "create a new team"
  option :permission, :default => "read",
                      :aliases => "p",
                      :desc => "Permission level of the team in the organization"
  def create(team_name)
    team = Sem::API::Team.create!(team_name, :permission => options[:permission])

    Sem::Views::Teams.info(team)
  end

  desc "rename", "change the name of the team"
  def rename(old_team_name, new_team_name)
    old_org_name, _old_name = Sem::SRN.parse_team(old_team_name)
    new_org_name, new_name = Sem::SRN.parse_team(new_team_name)

    abort "Team can't change its organization" unless new_org_name == old_org_name

    team = Sem::API::Team.find!(old_team_name)
    team = team.update(:name => new_name)

    Sem::Views::Teams.info(team)
  end

  desc "set-permission", "set the permission level of the team"
  option :permission, :default => "read",
                      :required => true,
                      :aliases => "p",
                      :desc => "Permission level of the team in the organization"
  def set_permission(team_name) # rubocop:disable Style/AccessorMethodName
    team = Sem::API::Team.find!(team_name)
    team = team.update(:permission => options[:permission])

    Sem::Views::Teams.info(team)
  end

  desc "delete", "removes a team from your organization"
  def delete(team_name)
    team = Sem::API::Team.find!(team_name)
    team.delete!

    puts "Team #{team_name} deleted."
  end

  class Members < Dracula
    desc "list", "lists members of the team"
    def list(team_name)
      team = Sem::API::Team.find!(team_name)
      users = team.users

      if !users.empty?
        Sem::Views::Users.list(users)
      else
        Sem::Views::Teams.add_first_team_member(team)
      end
    end

    desc "add", "add a user to the team"
    def add(team_name, username)
      team = Sem::API::Team.find!(team_name)
      team.add_user(username)

      puts "User #{username} added to the team."
    end

    desc "remove", "removes a user from the team"
    def remove(team_name, username)
      team = Sem::API::Team.find!(team_name)

      if team.users.map(&:username).include?(username)
        team.remove_user(username)

        puts "User #{username} removed from the team."
      else
        puts "User #{username} is not a member of the team."
      end
    end
  end

  class Projects < Dracula
    desc "list", "lists projects in a team"
    def list(team_name)
      team = Sem::API::Team.find!(team_name)
      projects = team.projects

      if !projects.empty?
        Sem::Views::Projects.list(projects)
      else
        Sem::Views::Teams.add_first_project(team)
      end
    end

    desc "add", "add a project to a team"
    def add(team_name, project_name)
      team = Sem::API::Team.find!(team_name)
      project = Sem::API::Project.find!(project_name)

      team.add_project(project)

      puts "Project #{project_name} added to the team."
    end

    desc "remove", "removes a project from the team"
    def remove(team_name, project_name)
      team = Sem::API::Team.find!(team_name)
      project = Sem::API::Project.find!(project_name)

      team.remove_project(project)

      puts "Project #{project_name} removed from the team."
    end
  end

  class SharedConfigs < Dracula
    desc "list", "list shared configurations in a team"
    def list(team_name)
      team = Sem::API::Team.find!(team_name)
      configs = team.shared_configs

      if !configs.empty?
        Sem::Views::SharedConfigs.list(configs)
      else
        Sem::Views::Teams.add_first_shared_config(team)
      end
    end

    desc "add", "add a shared configuration to a team"
    def add(team_name, shared_config_name)
      team = Sem::API::Team.find!(team_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      team.add_shared_config(shared_config)

      puts "Shared Configuration #{shared_config_name} added to the team."
    end

    desc "remove", "removes a shared Configuration from the team"
    def remove(team_name, shared_config_name)
      team = Sem::API::Team.find!(team_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      team.remove_shared_config(shared_config)

      puts "Shared Configuration #{shared_config_name} removed from the team."
    end
  end

  register "members", "manage team members", Members
  register "projects", "manage team members", Projects
  register "shared-configs", "manage shared configurations", SharedConfigs
end
