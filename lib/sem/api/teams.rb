module Sem
  module API
    class Teams < Base
      def self.list
        new.list
      end

      def self.list_for_org(org_name)
        new.list_for_org(org_name)
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
        org_names = Sem::API::Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def list_for_org(org_name)
        teams = api.list_for_org(org_name)

        teams.map { |team| to_hash(team) }
      end

      def info(path)
        org_name, team_name = path.split("/")

        list_for_org(org_name).find { |team| team[:name] == team_name }
      end

      def create(org_name, args)
        team = api.create_for_org(org_name, args)

        to_hash(team)
      end

      def delete(path)
        id = info(path)[:id]

        api.delete(id)
      end

      private

      def api
        client.teams
      end

      def to_hash(team)
        {
          :id => team.id,
          :name => team.name,
          :permission => team.permission,
          :members => client.users.list_for_team(team.id).count.to_s,
          :created_at => team.created_at,
          :updated_at => team.updated_at
        }
      end
    end
  end
end
