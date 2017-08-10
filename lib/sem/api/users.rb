module Sem
  module API
    class Users < Base
      def self.list
        new.list
      end

      def self.list_for_team(team_path)
        new.list_for_team(team_path)
      end

      def self.info(name)
        new.info(name)
      end

      def list
        org_names = client.orgs.list.map(&:username)

        users = org_names.map { |name| client.users.list_for_org(name) }.flatten

        users.map { |user| to_hash(user) }
      end

      def list_for_team(team_path)
        team = Teams.info(team_path)

        users = client.users.list_for_team(team[:id])

        users.map { |user| to_hash(user) }
      end

      def info(name)
        list.find { |user| user[:username] == name }
      end

      private

      def to_hash(user)
        {
          :id => user.uid,
          :username => user.username
        }
      end
    end
  end
end
