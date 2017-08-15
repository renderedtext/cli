module Sem
  class CLI < Sem::ThorExt::TopLevelThor
    require_relative "cli/orgs"
    require_relative "cli/projects"
    require_relative "cli/teams"
    require_relative "cli/shared_configs"

    desc "login", "log in to semaphore from the command line"
    def login
      puts "NOT IMPLEMENTED"
    end

    desc "orgs", "manage organizations"
    subcommand "orgs", Sem::CLI::Orgs

    desc "teams", "manage teams and team membership"
    subcommand "teams", Sem::CLI::Teams

    desc "shared_configs", "manage shared configurations"
    subcommand "shared_configs", Sem::CLI::SharedConfigs

    desc "projects", "manage projects"
    subcommand "projects", Sem::CLI::Projects
  end
end
