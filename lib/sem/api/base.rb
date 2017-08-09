module Sem
  module API
    class Base
      CREDENTIALS_PATH = "~/.sem/credentials".freeze

      protected

      def client
        @client ||= begin
          auth_token = File.read(CREDENTIALS_PATH)

          SemaphoreClient.new(auth_token)
        end
      end
    end
  end
end
