module Sem
  module API
    class EnvVars < Base
      extend Traits::AssociatedWithSharedConfig

      def self.api
        client.env_vars
      end

      def self.to_hash(env_var)
        {
          :id => env_var.id,
          :name => env_var.name
        }
      end
    end
  end
end
