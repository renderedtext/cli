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

    def run_in_trace_mode!
      @trace_mode = true
    end

    # Returns exit status as a number.
    # rubocop:disable Metrics/AbcSize
    def start(args)
      args.delete("--trace") && run_in_trace_mode! if args.include?("--trace")

      Sem::CLI.start(args)
    rescue Sem::Errors::Base => e
      abort e.message
    rescue SemaphoreClient::Exceptions::Conflict, SemaphoreClient::Exceptions::NotAllowed => e
      abort "[ERROR] #{e.message}"
    rescue SemaphoreClient::Exceptions::Unauthorized => e
      abort "[ERROR] #{e.message}. Check if your credentials are valid."
    rescue SemaphoreClient::Exceptions::ServerError => e
      abort on_server_error(e)
    rescue SemaphoreClient::Exceptions::UnprocessableEntity => e
      abort "[ERROR] #{e.message}"
    rescue StandardError => e
      abort on_unhandled_error(e)
    end

    private

    def on_server_error(exception)
      [
        "[ERROR] Semaphore API returned status #{exception.code}.",
        "",
        exception.message,
        "",
        "Please report this issue to https://semaphoreci.com/support."
      ].join("\n")
    end

    def on_unhandled_error(exception)
      [
        "[PANIC] Unhandled error.",
        "",
        "Well, this is embarrassing. An unknown error was detected.",
        "",
        "#{exception.class.name}: #{exception.message}",
        "",
        "Backtrace: ",
        exception.backtrace,
        "",
        "Please report this issue by opening an issue on GitHub: https://github.com/renderedtext/cli/issues/new."
      ].join("\n")
    end
  end

end
