module Sem
  module API
    class Base
      class << self
        def client
          @client ||= SemaphoreClient.new(
            Sem::Configuration.auth_token,
            :api_url => Sem::Configuration.api_url,
            :verbose => (Sem.log_level == Sem::LOG_LEVEL_TRACE)
          )
        end
      end
    end
  end
end
