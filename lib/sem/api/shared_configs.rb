module Sem
  module API
    class SharedConfigs < Base
      extend Traits::AssociatedWithTeam
      extend Traits::AssociatedWithOrg

      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.info(org_name, shared_config_name)
        list_for_org(org_name).find { |shared_config| shared_config[:name] == shared_config_name }
      end

      def self.create(org_name, args)
        shared_config = api.create_for_org(org_name, args)

        to_hash(shared_config)
      end

      def self.update(org_name, shared_config_name, args)
        shared_config = info(org_name, shared_config_name)

        shared_config = api.update(shared_config[:id], args)

        to_hash(shared_config)
      end

      def self.delete(org_name, shared_config_name)
        id = info(org_name, shared_config_name)[:id]

        api.delete(id)
      end

      def self.list_env_vars(org_name, shared_config_name)
        Sem::API::EnvVars.list_for_shared_config(org_name, shared_config_name)
      end

      def self.list_files(org_name, shared_config_name)
        Sem::API::Files.list_for_shared_config(org_name, shared_config_name)
      end

      def self.api
        client.shared_configs
      end

      def self.to_hash(shared_config)
        return if shared_config.nil?

        {
          :id => shared_config.id,
          :name => shared_config.name,
          :config_files => config_files_count(shared_config.id),
          :env_vars => env_vars_count(shared_config.id),
          :created_at => shared_config.created_at,
          :updated_at => shared_config.updated_at
        }
      end

      class << self
        private

        def config_files_count(shared_config_id)
          client.config_files.list_for_shared_config(shared_config_id).to_a.size
        end

        def env_vars_count(shared_config_id)
          client.env_vars.list_for_shared_config(shared_config_id).to_a.size
        end
      end
    end
  end
end
