module Sem
  class CLI < Dracula
    program_name "sem"

    require_relative "cli/orgs"
    require_relative "cli/projects"
    require_relative "cli/teams"
    require_relative "cli/shared_configs"

    desc "login", "Log in to semaphore from the command line"
    option :auth_token, :required => true
    long_desc <<-DESC
You can find your auth_token on the bottom of the users settings page https://semaphoreci.com/users/edit.
DESC
    def login
      auth_token = options[:auth_token]

      if Sem::Configuration.valid_auth_token?(auth_token)
        Sem::Configuration.export_auth_token(auth_token)

        puts "Your credentials have been saved to #{Sem::Configuration::CREDENTIALS_PATH}."
      else
        abort "[ERROR] Token is invalid!"
      end
    end

    desc "logout", "Log out from semaphore"
    def logout
      Sem::Configuration.delete_auth_token

      puts "Loged out."
    end

    register "orgs", "manage organizations", Sem::CLI::Orgs
    register "teams", "manage teams and team membership", Sem::CLI::Teams
    register "shared-configs", "manage shared configurations", Sem::CLI::SharedConfigs
    register "projects", "manage projects", Sem::CLI::Projects
  end
end
