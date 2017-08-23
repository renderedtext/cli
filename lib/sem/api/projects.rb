module Sem
  module API
    class Projects < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      class << self
        def list
          org_names = Orgs.list.map { |org| org[:username] }

          org_names.pmap { |name| list_for_org(name) }.flatten
        end

        def info(org_name, project_name)
          project = api.list_for_org(org_name, :name => project_name).first

          raise_not_found("Project", [org_name, project_name]) if project.nil?

          to_hash(project, org_name)
        end

        def api
          client.projects
        end

        def to_hash(project, org)
          {
            :id => project.id,
            :name => project.name,
            :org => org,
            :created_at => project.created_at,
            :updated_at => project.updated_at
          }
        end
      end
    end
  end
end
