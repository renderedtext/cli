module Sem::Errors
  Base = Class.new(StandardError)

  InvalidSRN = Class.new(StandardError)
  OrgNamesNotMatching = Class.new(StandardError)

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
    NoCredentials = Class.new(Sem::Errors::Base)
    InvalidCredentials = Class.new(Sem::Errors::Base)
  end
end
