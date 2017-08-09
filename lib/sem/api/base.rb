module Sem
  module API
    class Base
      CREDENTIALS_PATH = "~/.sem/credentials".freeze

      protected

      def client
        @client ||= begin
          path = File.expand_path(CREDENTIALS_PATH)

          auth_token = File.read(path).delete("\n")

          SemaphoreClient.new(auth_token)
        end
      end
    end
  end
end
