module Sem
  module API
    module Traits
      module AssociatedWithOrg
        PAGES_PER_CALL = 3

        def list_for_org(org_name, filter_query = nil)
          pages = Sem::Pagination.pages(PAGES_PER_CALL) do |page_index|
            call_query = { :page => page_index }

            call_query.merge!(filter_query) unless filter_query.nil?

            api.list_for_org(org_name, call_query).to_a
          end

          pages.flatten.pmap { |instance| to_hash(instance, org_name) }
        end
      end
    end
  end
end
