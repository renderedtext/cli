module Sem
  class Credentials
    PATH = File.expand_path("~/.sem/credentials").freeze

    def self.write(auth_token)
      File.write(PATH, auth_token)
    end

    def self.read
      File.read(PATH).delete("\n")
    end
  end
end
