module Sem
  module API
    class Base
      def self.client
        @client ||= SemaphoreClient.new(
          Sem::Configuration.auth_token,
          Sem::Configuration.api_url
        )
      end
    end
  end
end
