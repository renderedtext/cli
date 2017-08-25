module Sem
  module API
    class SharedConfigs < Base
      extend Traits::AssociatedWithTeam
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithProject

      class << self
        def list
          org_names = Orgs.list.map { |org| org[:username] }

          org_names.pmap { |name| list_for_org(name) }.flatten
        end

        def info(org_name, shared_config_name)
          selected_shared_config = list_for_org(org_name).find do |shared_config|
            shared_config[:name] == shared_config_name
          end

          if selected_shared_config.nil?
            raise Sem::Errors::ResourceNotFound.new("Shared Configuration", [org_name, shared_config_name])
          end

          selected_shared_config
        end

        def create(org_name, args)
          shared_config = api.create_for_org(org_name, args)

          if shared_config.nil?
            raise Sem::Errors::ResourceNotCreated.new("Shared Configuration", [org_name, args[:name]])
          end

          to_hash(shared_config, org_name)
        end

        def update(org_name, shared_config_name, args)
          shared_config = info(org_name, shared_config_name)

          shared_config = api.update(shared_config[:id], args)

          if shared_config.nil?
            raise Sem::Errors::ResourceNotUpdated.new("Shared Configuration", [org_name, shared_config_name])
          end

          to_hash(shared_config, org_name)
        end

        def delete(org_name, shared_config_name)
          shared_config = info(org_name, shared_config_name)

          api.delete!(shared_config[:id])
        rescue SemaphoreClient::Exceptions::RequestFailed
          raise Sem::Errors::ResourceNotDeleted.new("Shared Configuration", [org_name, shared_config_name])
        end

        def list_env_vars(org_name, shared_config_name)
          Sem::API::EnvVars.list_for_shared_config(org_name, shared_config_name)
        end

        def list_files(org_name, shared_config_name)
          Sem::API::Files.list_for_shared_config(org_name, shared_config_name)
        end

        def api
          client.shared_configs
        end

        def to_hash(shared_config, org)
          network_actions = [:config_files_count, :env_vars_count]

          config_files, env_vars = network_actions.pmap do |action|
            send(action, shared_config.id)
          end

          {
            :id => shared_config.id,
            :name => shared_config.name,
            :org => org,
            :config_files => config_files,
            :env_vars => env_vars,
            :created_at => shared_config.created_at,
            :updated_at => shared_config.updated_at
          }
        end

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
