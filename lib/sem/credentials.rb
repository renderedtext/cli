module Sem
  class Credentials
    PATH = File.expand_path("~/.sem/credentials").freeze

    def self.write(auth_token)
      File.write(PATH, auth_token)
      File.chmod(0o0600, PATH)
    end

    def self.read
      raise Sem::Errors::Auth::NoCredentials unless File.file?(PATH)

      File.read(PATH).strip
    end
  end
end
