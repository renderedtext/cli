require "sem/version"
require "dracula"
require "semaphore_client"

module Sem
  require "sem/errors"
  require "sem/cli"
  require "sem/api"
  require "sem/views"

  def start(args)
    Sem::CLI.start(args)
  rescue Sem::Errors::Auth::NoCredentials
    puts "[ERROR] You are not logged in."
    puts ""
    puts "Please log in with '#{Sem.program_name} login --auth-token <token>'"
    puts
    exit 1
  rescue Sem::Errors::Auth::InvalidCredentils
    puts "[ERROR] Your credentils are invalid."
    puts ""
    puts "Please re-log in with '#{Sem.program_name} login --auth-token <token>'"
    puts
    exit 1
  end
end
