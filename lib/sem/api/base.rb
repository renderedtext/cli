module Sem
  module API
    class Base
      def self.client
        @client ||= begin
          auth_token = Sem::Credentials.read

          SemaphoreClient.new(auth_token)
        end
      end

      def self.check_path_format(path, pattern)
        return if path.split("/").count == pattern.split("/").count

        raise Sem::Errors::InvalidPath, pattern
      end
    end
  end
end
