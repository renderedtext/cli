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

        def raise_not_created(resource, path)
          raise Sem::Errors::Resource::NotCreated,
                "[ERROR] #{resource} creation failed\n\n#{resource} #{path.join("/")} not created."
        end

        def raise_not_found(resource, path)
          raise Sem::Errors::Resource::NotFound,
                "[ERROR] #{resource} lookup failed\n\n#{resource} #{path.join("/")} not found."
        end

        def raise_not_updated(resource, path)
          raise Sem::Errors::Resource::NotUpdated,
                "[ERROR] #{resource} update failed\n\n#{resource} #{path.join("/")} not updated."
        end

        def raise_not_deleted(resource, path)
          raise Sem::Errors::Resource::NotDeleted, "#{resource} #{path.join("/")} not deleted."
        end
      end
    end
  end
end
