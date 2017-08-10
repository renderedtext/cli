module Sem
  class CLI < Sem::ThorExt::TopLevelThor
    require_relative "cli/users"
    require_relative "cli/projects"
    require_relative "cli/configs"
    require_relative "cli/teams"

    desc "login", "log in to semaphore from the command line"
    def login
      puts "NOT IMPLEMENTED"
    end

    desc "teams", "manage teams and team membership"
    subcommand "teams", Sem::CLI::Teams
  end
end
