module Sem
  module API
    class Configs < Base
      def self.list_for_org(org_name)
        new.list_for_org(org_name)
      end

      def list_for_org(org_name)
        configs = api.list_for_org(org_name)

        configs.map { |config| to_hash(config) }
      end

      private

      def api
        client.shared_configs
      end

      def to_hash(configs)
        {
          :id => configs.id,
          :name => configs.name
        }
      end
    end
  end
end
