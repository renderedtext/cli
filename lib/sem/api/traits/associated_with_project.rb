module Sem
  module API
    module Traits
      module AssociatedWithProject
        def list_for_project(org_name, project_name)
          project = Projects.info(org_name, project_name)

          instances = api.list_for_project(project[:id]).to_a

          instances.map { |instance| to_hash(instance, org_name) }
        end

        def add_to_project(org_name, project_name, instance_name)
          instance = info(org_name, instance_name)
          project = Projects.info(org_name, project_name)

          api.attach_to_project(instance[:id], project[:id])
        end

        def remove_from_project(org_name, project_name, instance_name)
          instance = info(org_name, instance_name)
          project = Projects.info(org_name, project_name)

          api.detach_from_project(instance[:id], project[:id])
        end
      end
    end
  end
end
