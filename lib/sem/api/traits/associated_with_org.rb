module Sem
  module API
    module Traits
      module AssociatedWithOrg
        def list_for_org(org_name)
          instances = api.list_for_org(org_name)

          instances.map { |instance| to_hash(instance) }
        end
      end
    end
  end
end
