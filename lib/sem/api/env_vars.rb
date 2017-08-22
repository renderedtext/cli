module Sem
  module API
    class EnvVars < Base
      extend Traits::AssociatedWithSharedConfig

      class << self
        def api
          client.env_vars
        end

        def to_hash(env_var)
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
end
