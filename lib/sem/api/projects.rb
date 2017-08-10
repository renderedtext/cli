module Sem
  module API
    class Projects < Base
      def self.list
        new.list
      end

      def list
        org_names = Orgs.list.map { |org| org[:username] }

        projects = org_names.map { |name| api.list_for_org(name) }.flatten

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
