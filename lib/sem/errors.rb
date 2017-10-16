module Sem::Errors
  Base = Class.new(StandardError)

  class InvalidSRN < StandardError
    def message
      [
        "[ERROR] Invalid parameter formatting.",
        "",
        super
      ].join("\n")
    end
  end

  class ResourceException < Base
    def initialize(resource, path)
      @resource = resource
      @path = path
    end
  end

  class ResourceNotFound < ResourceException
    def message
      "[ERROR] #{@resource} lookup failed\n\n#{@resource} #{@path.join("/")} not found."
    end
  end

  class ResourceNotCreated < ResourceException
    def message
      "[ERROR] #{@resource} creation failed\n\n#{@resource} #{@path.join("/")} not created."
    end
  end

  class ResourceNotUpdated < ResourceException
    def message
      "[ERROR] #{@resource} update failed\n\n#{@resource} #{@path.join("/")} not updated."
    end
  end

  class ResourceNotDeleted < ResourceException
    def message
      "[ERROR] #{@resource} deletion failed\n\n#{@resource} #{@path.join("/")} not deleted."
    end
  end

  module Auth
    class NoCredentials < Sem::Errors::Base
      def message
        [
          "[ERROR] You are not logged in.",
          "",
          "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"
        ].join("\n")
      end
    end

    class InvalidCredentials < Sem::Errors::Base
      def message
        [
          "[ERROR] Your credentials are invalid.",
          "",
          "Log in with '#{Sem::CLI.program_name} login --auth-token <token>'"
        ].join("\n")
      end
    end
  end
end
