module Sem
  module API
    class Files < Base
      extend Traits::AssociatedWithSharedConfig

      def self.api
        client.config_files
      end

      def self.to_hash(files)
        {
          :id => files.id,
          :name => files.path,
          :encrypted? => files.encrypted
        }
      end
    end
  end
end
