module Sem
  module API
    class Projects < Base
      def self.list
        new.list
      end

      def self.list_for_org(org_name)
        new.list_for_org(org_name)
      end

      def list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def list_for_org(org_name)
        projects = api.list_for_org(org_name)

        projects.map { |project| to_hash(project) }
      end

      private

      def api
        client.projects
      end

      def to_hash(project)
        {
          :id => project.id,
          :name => project.name
        }
      end
    end
  end
end
