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
  rescue Sem::Errors::Auth::InvalidCredentials
    puts "[ERROR] Your credentials are invalid."
    puts ""
    puts "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"

    1
  rescue StandardError => e
    puts "[PANIC] Unhandled error."
    puts ""
    puts "Well, this is emberassing. An unknown error was detected."
    puts "Please report this issue to https://semaphoreci.com/support."
    puts ""
    puts "Backtrace: "
    puts e.backtrace

    1
  end
end
