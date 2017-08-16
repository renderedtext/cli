module Sem
  module API
    class Files < Base
      extend Traits::AssociatedWithSharedConfig

      def self.api
        client.config_files
      end

      def self.to_hash(env_var)
        {
          :id => env_var.id,
          :name => env_var.path
        }
      end
    end
  end
end
