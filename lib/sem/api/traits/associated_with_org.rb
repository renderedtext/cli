module Sem
  module API
    module Traits
      module AssociatedWithOrg
        def list_for_org(org_name)
          instances = api.list_for_org(org_name).to_a

          instances.map { |instance| to_hash(instance, org_name) }
        end
      end
    end
  end
end
