module Sem
  class CLI < Dracula
    program_name "sem"

    require_relative "cli/orgs"
    require_relative "cli/projects"
    require_relative "cli/teams"
    require_relative "cli/secrets"

    desc "version", "Display CLI version"
    def version
      puts Sem::VERSION
    end

    desc "login", "Log in to Semaphore from the command line"
    option "auth-token", :required => true
    long_desc <<-DESC
Examples:

    $ sem login --auth-token abcd12345
    Your credentials have been saved to #{Sem::Configuration::CREDENTIALS_PATH}."

You can find your auth-token on the bottom of the users settings page <https://semaphoreci.com/users/edit>.
DESC
    def login
      auth_token = options["auth-token"]

      if Sem::Configuration.valid_auth_token?(auth_token)
        Sem::Configuration.export_auth_token(auth_token)

        puts "Your credentials have been saved to #{Sem::Configuration::CREDENTIALS_PATH}."
      else
        abort "[ERROR] Token is invalid!"
      end
    end

    desc "logout", "Log out from semaphore"
    long_desc <<-DESC
Examples:

    $ sem logout
    Logged out.
DESC
    def logout
      Sem::Configuration.delete_auth_token

      puts "Logged out."
    end

    register "orgs", "manage organizations", Sem::CLI::Orgs
    register "teams", "manage teams and team membership", Sem::CLI::Teams
    register "secrets", "manage secrets", Sem::CLI::Secrets
    register "projects", "manage projects", Sem::CLI::Projects
  end
end
