module Sem
  class Configuration
    CREDENTIALS_PATH = File.expand_path("~/.sem/credentials").freeze
    API_URL_PATH = File.expand_path("~/.sem/api_url").freeze

    DEFAULT_API_URL = "https://api.semaphoreci.com".freeze

    class << self
      def valid_auth_token?(auth_token)
        client = SemaphoreClient.new(auth_token, api_url)
        client.orgs.list!

        true
      rescue SemaphoreClient::Exceptions::RequestFailed
        false
      end

      def export_auth_token(auth_token)
        dirname = File.dirname(CREDENTIALS_PATH)
        FileUtils.mkdir_p(dirname)

        File.write(CREDENTIALS_PATH, auth_token)
        File.chmod(0o0600, CREDENTIALS_PATH)
      end

      def auth_token
        raise Sem::Errors::Auth::NoCredentials unless File.file?(CREDENTIALS_PATH)

        File.read(CREDENTIALS_PATH).strip
      end

      def api_url
        return DEFAULT_API_URL unless File.file?(API_URL_PATH)

        File.read(API_URL_PATH).strip
      end
    end
  end
end
