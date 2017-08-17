module Sem
  module API
    class SharedConfigs < Base
      extend Traits::AssociatedWithTeam
      extend Traits::AssociatedWithOrg

      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.info(path)
        org_name, config_name = path.split("/")

        list_for_org(org_name).find { |config| config[:name] == config_name }
      end

      def self.list_env_vars(path)
        Sem::API::EnvVars.list_for_shared_config(path)
      end

      def self.list_files(path)
        Sem::API::Files.list_for_shared_config(path)
      end

      def self.api
        client.shared_configs
      end

      def self.to_hash(configs)
        {
          :id => configs.id,
          :name => configs.name,
          :config_files => client.config_files.list_for_shared_config(configs.id).to_a.count,
          :env_vars => client.env_vars.list_for_shared_config(configs.id).to_a.count
        }
      end
    end
  end
end
