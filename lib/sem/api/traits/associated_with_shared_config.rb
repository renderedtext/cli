module Sem
  module API
    module Traits
      module AssociatedWithSharedConfig
        def list_for_shared_config(org_name, shared_config_name)
          shared_config = SharedConfigs.info(org_name, shared_config_name)

          instances = api.list_for_shared_config(shared_config[:id]).to_a

          instances.map { |instance| to_hash(instance) }
        end

        def add_to_shared_config(org_name, shared_config_name, params)
          shared_config = SharedConfigs.info(org_name, shared_config_name)

          api.create_for_shared_config(shared_config[:id], params)
        end

        def remove_from_shared_config(org_name, shared_config_name, instance_name)
          instances = list_for_shared_config(org_name, shared_config_name)

          selected_instance = instances.find { |instance| instance[:name] == instance_name }

          raise_not_found("Resource", [org_name, instance_name]) if selected_instance.nil?

          api.delete(selected_instance[:id])
        end
      end
    end
  end
end
