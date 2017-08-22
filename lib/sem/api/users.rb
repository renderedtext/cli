module Sem
  module API
    class Users < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.info(*args)
        name = args.count == 2 ? args[1] : args[0]

        list.find { |user| user[:id] == name }
      end

      def self.api
        client.users
      end

      def self.to_hash(user)
        return if user.nil?

        { :id => user.username }
      end
    end
  end
end
