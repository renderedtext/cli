module Sem
  module API
    module Traits
      module AssociatedWithSharedConfig
        def list_for_shared_config(shared_config_path)
          shared_config = SharedConfigs.info(shared_config_path)

          instances = api.list_for_shared_config(shared_config[:id])

          instances.map { |instance| to_hash(instance) }
        end

        def add_to_shared_config(shared_config_path, params)
          shared_config = SharedConfigs.info(shared_config_path)

          api.create_for_shared_config(shared_config[:id], params)
        end

        def remove_from_shared_config(shared_config_path, instance_name)
          instances = list_for_shared_config(shared_config_path)

          selected_instance = instances.find { |instance| instance[:name] == instance_name }

          api.delete(selected_instance[:id])
        end
      end
    end
  end
end
