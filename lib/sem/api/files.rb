module Sem
  module API
    class Files < Base
      extend Traits::AssociatedWithSharedConfig

      def self.api
        client.config_files
      end

      def self.to_hash(file)
        return if file.nil?

        {
          :id => file.id,
          :name => file.path,
          :encrypted? => file.encrypted
        }
      end
    end
  end
end
