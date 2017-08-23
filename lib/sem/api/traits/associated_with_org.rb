module Sem
  module API
    module Traits
      module AssociatedWithOrg
        def list_for_org(org_name, query = nil)
          instances = api.list_for_org(org_name, query).to_a

          instances.pmap { |instance| to_hash(instance, org_name) }
        end
      end
    end
  end
end
