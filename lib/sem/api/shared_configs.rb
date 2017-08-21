module Sem
  module API
    class SharedConfigs < Base
      extend Traits::AssociatedWithTeam
      extend Traits::AssociatedWithOrg

      PATH_PATTERN = "org/shared_config".freeze

      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.info(path)
        check_path(path)

        org_name, config_name = path.split("/")

        list_for_org(org_name).find { |config| config[:name] == config_name }
      end

      def self.create(org_name, args)
        config = api.create_for_org(org_name, args)

        to_hash(config)
      end

      def self.update(path, args)
        check_path(path)

        shared_config = info(path)

        shared_config = api.update(shared_config[:id], args)

        to_hash(shared_config)
      end

      def self.delete(path)
        check_path(path)

        id = info(path)[:id]

        api.delete(id)
      end

      def self.list_env_vars(path)
        Sem::API::EnvVars.list_for_shared_config(path)
      end

      def self.list_files(path)
        Sem::API::Files.list_for_shared_config(path)
      end

      def self.check_path(path)
        check_path_format(path, PATH_PATTERN)
      end

      def self.api
        client.shared_configs
      end

      def self.to_hash(config)
        {
          :id => config.id,
          :name => config.name,
          :config_files => config_files_count(config.id),
          :env_vars => env_vars_count(config.id),
          :created_at => config.created_at,
          :updated_at => config.updated_at
        }
      end

      class << self
        private

        def config_files_count(config_id)
          client.config_files.list_for_shared_config(config_id).to_a.size
        end

        def env_vars_count(config_id)
          client.env_vars.list_for_shared_config(config_id).to_a.size
        end
      end
    end
  end
end
