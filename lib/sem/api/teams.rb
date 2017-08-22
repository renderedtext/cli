module Sem
  module API
    class Teams < Base
      extend Traits::AssociatedWithOrg

      class << self
        def list
          org_names = Sem::API::Orgs.list.map { |org| org[:username] }

          org_names.map { |name| list_for_org(name) }.flatten
        end

        def info(org_name, team_name)
          selected_team = list_for_org(org_name).find { |team| team[:name] == team_name }

          raise_not_found([org_name, team_name]) if selected_team.nil?

          selected_team
        end

        def create(org_name, args)
          team = api.create_for_org(org_name, args)

          to_hash(team)
        end

        def update(org_name, team_name, args)
          team = info(org_name, team_name)

          raise_not_found([org_name, team_name]) if team.nil?

          team = api.update(team[:id], args)

          to_hash(team)
        end

        def delete(org_name, team_name)
          team = info(org_name, team_name)

          raise_not_found([org_name, team_name]) if team.nil?

          api.delete(team[:id])
        end

        def api
          client.teams
        end

        def to_hash(team)
          {
            :id => team.id,
            :name => team.name,
            :permission => team.permission,
            :members => client.users.list_for_team(team.id).to_a.size.to_s,
            :created_at => team.created_at,
            :updated_at => team.updated_at
          }
        end
      end
    end
  end
end
