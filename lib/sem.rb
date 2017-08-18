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
    on_no_credentials

    1
  rescue Sem::Errors::Auth::InvalidCredentials
    on_invalid_credentials

    1
  rescue StandardError => e
    on_unhandled_error(e)

    1
  end

  private_class_method def self.on_no_credentials
    puts "[ERROR] You are not logged in."
    puts ""
    puts "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"
  end

  private_class_method def self.on_invalid_credentials
    puts "[ERROR] Your credentials are invalid."
    puts ""
    puts "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"
  end

  private_class_method def self.on_unhandled_error(exception)
    puts "[PANIC] Unhandled error."
    puts ""
    puts "Well, this is emberassing. An unknown error was detected."
    puts ""
    puts "Backtrace: "
    puts exception.backtrace
    puts ""
    puts "Please report this issue to https://semaphoreci.com/support."
  end

end
