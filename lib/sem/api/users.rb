module Sem
  module API
    class Users < Base
      def self.list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def self.list_for_org(org_name)
        users = api.list_for_org(org_name)

        users.map { |user| to_hash(user) }
      end

      def self.list_for_team(team_path)
        team = Teams.info(team_path)

        users = api.list_for_team(team[:id])

        users.map { |user| to_hash(user) }
      end

      def self.info(name)
        list.find { |user| user[:username] == name }
      end

      def self.add_to_team(team_path, user_name)
        user = info(user_name)
        team = Teams.info(team_path)

        api.attach_to_team(user[:id], team[:id])
      end

      def self.remove_from_team(team_path, user_name)
        user = info(user_name)
        team = Teams.info(team_path)

        api.detach_from_team(user[:id], team[:id])
      end

      def self.api
        client.users
      end

      def self.to_hash(user)
        {
          :id => user.uid,
          :username => user.username
        }
      end
    end
  end
end
