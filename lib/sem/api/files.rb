module Sem
  module API
    class Files < Base
      extend Traits::AssociatedWithSharedConfig

      class << self
        def api
          client.config_files
        end

        def to_hash(file)
          {
            :id => file.id,
            :name => file.path,
            :encrypted? => file.encrypted
          }
        end
      end
    end
  end
end
