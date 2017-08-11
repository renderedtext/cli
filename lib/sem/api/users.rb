module Sem
  module API
    class Users < Base
      include Traits::AssociatedWithOrg
      include Traits::AssociatedWithTeam

      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.info(name)
        list.find { |user| user[:id] == name }
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
