module Sem
  class Credentials
    PATH = File.expand_path("~/.sem/credentials").freeze

    def self.valid?(auth_token)
      client = SemaphoreClient::HttpClient.new(auth_token)
      SemaphoreClient::Api::Org.new(client).list!

      true
    rescue SemaphoreClient::Exceptions::RequestFailed
      false
    end

    def self.write(auth_token)
      dirname = File.dirname(PATH)
      FileUtils.mkdir_p(dirname)

      File.write(PATH, auth_token)
      File.chmod(0o0600, PATH)
    end

    def self.read
      raise Sem::Errors::Auth::NoCredentials unless File.file?(PATH)

      File.read(PATH).strip
    end

  end
end
