class Sem::CLI::Teams < Dracula

  ALLOWED_PERMISSIONS = ["admin", "edit", "read"].freeze

  desc "list", "list all your teams"
  long_desc <<-DESC
Examples:

    $ sem teams:list
    ID                                    NAME       PERMISSION  MEMBERS
    1bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/devs    write       2 members
    1bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/admins  write       0 members
DESC
  def list
    teams = Sem::API::Team.all

    if !teams.empty?
      Sem::Views::Teams.list(teams)
    else
      Sem::Views::Teams.create_first_team
    end
  end

  desc "info", "show information about a team"
  long_desc <<-DESC
Examples:

    $ sem teams:info renderedtext/admins
    ID          1bc7ed43-ac8a-487e-b488-c38bc757a034
    Name        renderedtext/admins
    Permission  edit
    Members     2 members
    Created     2017-08-01 13:14:40 +0200
    Updated     2017-08-02 13:14:40 +0200
DESC
  def info(team_name)
    team = Sem::API::Team.find!(team_name)

    Sem::Views::Teams.info(team)
  end

  desc "create", "create a new team"
  option :permission, :default => "read",
                      :aliases => "p",
                      :desc => "Permission level of the team in the organization"
  long_desc <<-DESC
Examples:

    $ sem teams:create renderedtext/interns
    ID          1bc7ed43-ac8a-487e-b488-c38bc757a034
    Name        renderedtext/interns
    Permission  read
    Members     0 members
    Created     2017-08-01 13:14:40 +0200
    Updated     2017-08-02 13:14:40 +0200

    $ sem teams:create renderedtext/devs --permission edit
    ID          1bc7ed43-ac8a-487e-b488-c38bc757a034
    Name        renderedtext/devs
    Permission  edit
    Members     0 members
    Created     2017-08-01 13:14:40 +0200
    Updated     2017-08-02 13:14:40 +0200

    $ sem teams:create renderedtext/admins --permission admin
    ID          1bc7ed43-ac8a-487e-b488-c38bc757a034
    Name        renderedtext/admins
    Permission  admin
    Members     0 members
    Created     2017-08-01 13:14:40 +0200
    Updated     2017-08-02 13:14:40 +0200
DESC
  def create(team_name)
    permission = options[:permission]

    unless ALLOWED_PERMISSIONS.include?(permission)
      abort "Permission must be one of [#{ALLOWED_PERMISSIONS.join(", ")}]"
    end

    team = Sem::API::Team.create!(team_name, :permission => permission)

    Sem::Views::Teams.info(team)
  end

  desc "rename", "change the name of the team"
  long_desc <<-DESC
Examples:

    $ sem teams:create renderedtext/interns renderedtext/juniors
    ID          1bc7ed43-ac8a-487e-b488-c38bc757a034
    Name        renderedtext/juniors
    Permission  read
    Members     0 members
    Created     2017-08-01 13:14:40 +0200
    Updated     2017-08-02 13:14:40 +0200
DESC
  def rename(old_team_name, new_team_name)
    old_org_name, _old_name = Sem::SRN.parse_team(old_team_name)
    new_org_name, new_name = Sem::SRN.parse_team(new_team_name)

    abort "Team can't change its organization" unless new_org_name == old_org_name

    team = Sem::API::Team.find!(old_team_name)
    team = team.update!(:name => new_name)

    Sem::Views::Teams.info(team)
  end

  desc "set-permission", "set the permission level of the team"
  option :permission, :default => "read",
                      :required => true,
                      :aliases => "p",
                      :desc => "Permission level of the team in the organization"
  long_desc <<-DESC
Examples:

    $ sem teams:set-permission renderedtext/interns --permission edit
    ID          1bc7ed43-ac8a-487e-b488-c38bc757a034
    Name        renderedtext/interns
    Permission  edit
    Members     0 members
    Created     2017-08-01 13:14:40 +0200
    Updated     2017-08-02 13:14:40 +0200
DESC
  def set_permission(team_name) # rubocop:disable Style/AccessorMethodName
    permission = options[:permission]

    unless ALLOWED_PERMISSIONS.include?(permission)
      abort "Permission must be one of [#{ALLOWED_PERMISSIONS.join(", ")}]"
    end

    team = Sem::API::Team.find!(team_name)
    team = team.update!(:permission => permission)

    Sem::Views::Teams.info(team)
  end

  desc "delete", "removes a team from your organization"
  long_desc <<-DESC
Examples:

    $ sem teams:delete renderedtext/interns
    Team renderedtext/interns deleted.
DESC
  def delete(team_name)
    team = Sem::API::Team.find!(team_name)
    team.delete!

    puts "Team #{team_name} deleted."
  end

  class Members < Dracula
    desc "list", "list members of the team"
    long_desc <<-DESC
Examples:

    $ sem teams:members:list renderedtext/interns
    NAME
    shiroyasha
    darko
    ervinb
DESC
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
    long_desc <<-DESC
Examples:

    $ sem teams:members:add renderedtext/interns shiroyasha
    User shiroyasha added to the team.
DESC
    def add(team_name, username)
      team = Sem::API::Team.find!(team_name)
      team.add_user(username)

      puts "User #{username} added to the team."
    end

    desc "remove", "remove a user from the team"
    long_desc <<-DESC
Examples:

    $ sem teams:members:remove renderedtext/interns shiroyasha
    User shiroyasha removed from the team.
DESC
    def remove(team_name, username)
      team = Sem::API::Team.find!(team_name)
      team.remove_user(username)

      puts "User #{username} removed from the team."
    end
  end

  class Projects < Dracula
    desc "list", "list projects in a team"
    long_desc <<-DESC
Examples:

    $ sem team:projects:list renderedtext/devs
    NAME
    ID                                    NAME
    99c7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/cli
    12c7ed43-4444-487e-b488-c38bc757a034  renderedtext/api
DESC
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
    long_desc <<-DESC
Examples:

    $ sem team:projects:add renderedtext/devs renderedtext/cli
    Project renderedtext/cli added to the team.
DESC
    def add(team_name, project_name)
      team = Sem::API::Team.find!(team_name)
      project = Sem::API::Project.find!(project_name)

      team.add_project(project)

      puts "Project #{project_name} added to the team."
    end

    desc "remove", "remove a project from the team"
    long_desc <<-DESC
Examples:

    $ sem team:projects:remove renderedtext/devs renderedtext/cli
    Project renderedtext/cli removed from the team.
DESC
    def remove(team_name, project_name)
      team = Sem::API::Team.find!(team_name)
      project = Sem::API::Project.find!(project_name)

      team.remove_project(project)

      puts "Project #{project_name} removed from the team."
    end
  end

  class SharedConfigs < Dracula
    desc "list", "list shared configurations in a team"
    long_desc <<-DESC
Examples:

    $ sem team:shared-configs:list renderedtext/devs
    ID                                    NAME                 CONFIG FILES  ENV VARS
    99c7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/tokens             1         0
    1133ed43-ac8a-487e-b488-c38bc757a044  renderedtext/secrets            0         1
DESC
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
    long_desc <<-DESC
Examples:

    $ sem team:shared-configs:add renderedtext/devs renderedtext/secrets
    Shared Configuration renderedtext/secrets added to the team.
DESC
    def add(team_name, shared_config_name)
      team = Sem::API::Team.find!(team_name)
      shared_config = Sem::API::SharedConfig.find!(shared_config_name)

      team.add_shared_config(shared_config)

      puts "Shared Configuration #{shared_config_name} added to the team."
    end

    desc "remove", "removes a shared Configuration from the team"
    long_desc <<-DESC
Examples:

    $ sem team:shared-configs:remove renderedtext/devs renderedtext/secrets
    Shared Configuration renderedtext/secrets removed from the team.
DESC
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
