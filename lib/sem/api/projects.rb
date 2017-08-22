module Sem
  module API
    class Projects < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      class << self
        def list
          org_names = Orgs.list.map { |org| org[:username] }

          org_names.map { |name| list_for_org(name) }.flatten
        end

        def info(org_name, project_name)
          selected_project = list_for_org(org_name).find { |project| project[:name] == project_name }

          raise_not_found([org_name, project_name]) if selected_project.nil?

          selected_project
        end

        def api
          client.projects
        end

        def to_hash(project)
          {
            :id => project.id,
            :name => project.name,
            :created_at => project.created_at,
            :updated_at => project.updated_at
          }
        end
      end
    end
  end
end
