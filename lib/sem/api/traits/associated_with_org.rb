module Sem
  module API
    module Traits
      module AssociatedWithOrg
        PAGES_PER_CALL = 3

        def list_for_org(org_name)
          pages = Sem::Pagination.pages(PAGES_PER_CALL) do |page_index|
            api.list_for_org(org_name, :page => page_index).to_a
          end

          pages.flatten.pmap { |instance| to_hash(instance, org_name) }
        end
      end
    end
  end
end
