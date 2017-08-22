module Sem
  module API
    class Base
      class << self
        def client
          @client ||= SemaphoreClient.new(
            Sem::Configuration.auth_token,
            Sem::Configuration.api_url
          )
        end

        def raise_not_found(resource, path)
          raise Sem::Errors::ResourceNotFound, "#{resource} #{path.join("/")} not found."
        end
      end
    end
  end
end
