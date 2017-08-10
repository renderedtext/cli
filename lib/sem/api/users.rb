module Sem
  module API
    class Users < Base
      def self.list
        new.list
      end

      def self.list_for_org(org_name)
        new.list_for_org(org_name)
      end

      def self.list_for_team(team_path)
        new.list_for_team(team_path)
      end

      def self.info(name)
        new.info(name)
      end

      def self.add_to_team(team_path, user_name)
        new.add_to_team(team_path, user_name)
      end

      def self.remove_from_team(team_path, user_name)
        new.remove_from_team(team_path, user_name)
      end

      def list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def list_for_org(org_name)
        users = api.list_for_org(org_name)

        users.map { |user| to_hash(user) }
      end

      def list_for_team(team_path)
        team = Teams.info(team_path)

        users = api.list_for_team(team[:id])

        users.map { |user| to_hash(user) }
      end

      def info(name)
        list.find { |user| user[:username] == name }
      end

      def add_to_team(team_path, user_name)
        user = info(user_name)
        team = Teams.info(team_path)

        api.attach_to_team(user[:id], team[:id])
      end

      def remove_from_team(team_path, user_name)
        user = info(user_name)
        team = Teams.info(team_path)

        api.detach_from_team(user[:id], team[:id])
      end

      private

      def api
        client.users
      end

      def to_hash(user)
        {
          :id => user.uid,
          :username => user.username
        }
      end
    end
  end
end
