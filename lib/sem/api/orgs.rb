module Sem
  module API
    class Orgs < Base
      def self.list
        orgs = api.list

        orgs.map { |org| to_hash(org) }
      end

      def self.info(name)
        org = api.get(name)

        to_hash(org)
      end

      def self.list_teams(name)
        Sem::API::Teams.list_for_org(name)
      end

      def self.list_users(name)
        Sem::API::Users.list_for_org(name)
      end

      def self.list_admins(name)
        admin_teams = list_teams(name).select { |team| team[:permission] == "admin" }

        admins = admin_teams.map { |team| client.users.list_for_team(team[:id]) }.flatten

        admins.map { |admin| Sem::API::Users.to_hash(admin) }
      end

      def self.list_owners(name)
        owners_team = list_teams(name).find { |team| team[:name] == "Owners" }

        owners = client.users.list_for_team(owners_team[:id])

        owners.map { |owner| Sem::API::Users.to_hash(owner) }
      end

      def self.api
        client.orgs
      end

      def self.to_hash(org)
        {
          :id => org.id,
          :username => org.username,
          :created_at => org.created_at,
          :updated_at => org.updated_at
        }
      end
    end
  end
end
