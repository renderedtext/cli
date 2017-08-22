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

        def raise_not_found(path)
          raise Sem::Errors::ResourceNotFound, path.join("/")
        end
      end
    end
  end
end
