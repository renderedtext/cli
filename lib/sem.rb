require "sem/version"
require "dracula"
require "semaphore_client"

module Sem
  require "sem/errors"
  require "sem/cli"
  require "sem/api"
  require "sem/views"

  # Returns exit status as a number.
  def self.start(args)
    Sem::CLI.start(args)

    0
  rescue Sem::Errors::Auth::NoCredentials
    puts "[ERROR] You are not logged in."
    puts ""
    puts "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"

    1
  rescue Sem::Errors::Auth::InvalidCredentils
    puts "[ERROR] Your credentials are invalid."
    puts ""
    puts "Log in with '#{Sem.program_name} login --auth-token <token>'"

    1
  end
end
