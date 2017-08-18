module Sem
  module API
    class Base
      def self.client
        @client ||= begin
          auth_token = Sem::Credentials.read

          SemaphoreClient.new(auth_token)
        end
      end
    end
  end
end
