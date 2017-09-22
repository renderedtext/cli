module Sem
  module API
    class Projects < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      class << self
        def name_to_id(org_name, project_name)
          info(org_name, project_name)[:id]
        end

        def list
          org_names = Orgs.list.map { |org| org[:username] }

          org_names.to_a.pmap { |name| list_for_org(name) }.flatten
        end

        def list_env_vars(org_name, project_name)
          Sem::API::EnvVars.list_for_project(org_name, project_name)
        end

        def list_files(org_name, project_name)
          Sem::API::Files.list_for_project(org_name, project_name)
        end

        def info(org_name, project_name)
          project = api.list_for_org(org_name, :name => project_name).first

          raise Sem::Errors::ResourceNotFound.new("Project", [org_name, project_name]) if project.nil?

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
