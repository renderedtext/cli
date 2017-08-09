module Sem
  module API
    class Teams < Base
      def self.list
        new.list
      end

      def self.info(path)
        new.info(path)
      end

      def self.create(org_name, args)
        new.create(org_name, args)
      end

      def self.delete(path)
        new.delete(path)
      end

      def list
        orgs = client.orgs.list

        teams = orgs.map { |org| client.teams.list_for_org(org.id) }.flatten

        teams.map { |team| team_hash(team) }
      end

      def info(path)
        org_name, team_name = path.split("/")

        list(org_name).find { |team| team[:name] == team_name }
      end

      def create(org_name, args)
        team = client.teams.create_for_org(org_name, args)

        team_hash(team)
      end

      def delete(path)
        id = info(path).id

        client.teams.delete(id)
      end

      private

      def team_hash(team)
        {
          :id => team.id,
          :name => team.name,
          :permission => team.permission,
          :members => client.users.list_for_team(team.id).count,
          :created_at => team.created_at,
          :updated_at => team.updated_at
        }
      end
    end
  end
end
