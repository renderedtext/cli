module Sem
  class CLI < Dracula
    program_name "sem"

    require_relative "cli/orgs"
    require_relative "cli/projects"
    require_relative "cli/teams"
    require_relative "cli/shared_configs"

    desc "login", "log in to semaphore from the command line"
    option :auth_token, :required => true
    def login
      auth_token = options[:auth_token]

      if Sem::Credentials.valid?(auth_token)
        Sem::Credentials.write(auth_token)

        puts "Your credentials have been saved to #{Sem::Credentials::PATH}."
      else
        abort "[ERROR] Token is invalid!"
      end
    end

    register "orgs", "manage organizations", Sem::CLI::Orgs
    register "teams", "manage teams and team membership", Sem::CLI::Teams
    register "shared-configs", "manage shared configurations", Sem::CLI::SharedConfigs
    register "projects", "manage projects", Sem::CLI::Projects
  end
end
