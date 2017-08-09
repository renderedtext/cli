class Sem::API::Base
  CREDENTIALS_PATH = "~/.sem/credentials"

  protected

  def client
    @client ||= begin
      auth_token = File.read(CREDENTIALS_PATH)

      SemaphoreClient.new(auth_token)
    end
  end
end
