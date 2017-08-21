module Sem
  module API
    class Users < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      PATH_PATTERN = "user".freeze

      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.info(path)
        check_path(path)

        list.find { |user| user[:id] == path }
      end

      def self.check_path(path)
        check_path_format(path, PATH_PATTERN)
      end

      def self.api
        client.users
      end

      def self.to_hash(user)
        { :id => user.username }
      end
    end
  end
end
