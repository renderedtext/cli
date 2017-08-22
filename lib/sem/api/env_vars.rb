module Sem
  module API
    class EnvVars < Base
      extend Traits::AssociatedWithSharedConfig

      def self.api
        client.env_vars
      end

      def self.to_hash(env_var)
        return if env_var.nil?

        {
          :id => env_var.id,
          :name => env_var.name,
          :encrypted? => env_var.encrypted,
          :content => env_var.content
        }
      end
    end
  end
end
