module Sem
  module API
    module Traits
      module AssociatedWithOrg
        def list_for_org(org_path)
          Sem::API::Orgs.check_path(org_path)

          instances = api.list_for_org(org_path)

          instances.map { |instance| to_hash(instance) }
        end
      end
    end
  end
end
