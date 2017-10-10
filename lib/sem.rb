require "sem/version"
require "dracula"
require "semaphore_client"
require "fileutils"
require "pmap"
require "delegate"

module Sem
  require "sem/helpers"
  require "sem/errors"
  require "sem/configuration"
  require "sem/srn"
  require "sem/cli"
  require "sem/api"
  require "sem/views"

  class << self
    attr_writer :log_level

    def trace?
      @trace_mode == true
    end

    # Returns exit status as a number.
    def start(args)
      if args.include?("--trace")
        @trace_mode = true

        args.delete("--trace")
      end

      Sem::CLI.start(args)

      0
    rescue Sem::Errors::ResourceNotFound => e
      puts e.message

      1
    rescue Sem::Errors::ResourceException => e
      puts e.message

      1
    rescue Sem::Errors::InvalidSRN => e
      on_invalid_srn(e)

      1
    rescue Sem::Errors::Auth::NoCredentials
      on_no_credentials

      1
    rescue Sem::Errors::Auth::InvalidCredentials
      on_invalid_credentials

      1
    rescue SemaphoreClient::Exceptions::ServerError => e
      on_server_error(e)

      1
    rescue StandardError => e
      on_unhandled_error(e)

      1
    end

    private

    def on_invalid_srn(exception)
      puts "[ERROR] Invalid parameter formatting."
      puts ""
      puts exception.message
    end

    def on_server_error(exception)
      puts "[ERROR] Semaphore API returned status #{exception.code}."
      puts ""
      puts "#{exception.message}"
      puts ""
      puts "Please report this issue to https://semaphoreci.com/support."
    end

    def on_no_credentials
      puts "[ERROR] You are not logged in."
      puts ""
      puts "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"
    end

    def on_invalid_credentials
      puts "[ERROR] Your credentials are invalid."
      puts ""
      puts "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"
    end

    def on_unhandled_error(exception)
      puts "[PANIC] Unhandled error."
      puts ""
      puts "Well, this is embarrassing. An unknown error was detected."
      puts ""
      puts "Exception:"
      puts exception.message
      puts ""
      puts "Backtrace: "
      puts exception.backtrace
      puts ""
      puts "Please report this issue to https://semaphoreci.com/support."
    end
  end

end
