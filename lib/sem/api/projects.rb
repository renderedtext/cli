module Sem
  module API
    class Projects < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      PATH_PATTERN = "org/project".freeze

      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.info(path)
        check_path(path)

        org_name, project_name = path.split("/")

        list_for_org(org_name).find { |project| project[:name] == project_name }
      end

      def self.check_path(path)
        check_path_format(path, PATH_PATTERN)
      end

      def self.api
        client.projects
      end

      def self.to_hash(project)
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
