module Sem
  module API
    class Teams < Base
      extend Traits::AssociatedWithOrg

      class << self
        def name_to_id(org_name, team_name)
          info(org_name, team_name)[:id]
        end

        def list
          org_names = Sem::API::Orgs.list.map { |org| org[:username] }

          org_names.to_a.pmap { |name| list_for_org(name) }.flatten
        end

        def info(org_name, team_name)
          selected_team = list_for_org(org_name).find { |team| team[:name] == team_name }

          raise Sem::Errors::ResourceNotFound.new("Team", [org_name, team_name]) if selected_team.nil?

          selected_team
        end

        def create(org_name, args)
          team = api.create_for_org(org_name, args)

          raise Sem::Errors::ResourceNotCreated.new("Team", [org_name, args[:name]]) if team.nil?

          to_hash(team, org_name)
        end

        def update(org_name, team_name, args)
          team = info(org_name, team_name)

          team = api.update(team[:id], args)

          raise Sem::Errors::ResourceNotUpdated.new("Team", [org_name, team_name]) if team.nil?

          to_hash(team, org_name)
        end

        def delete(org_name, team_name)
          team = info(org_name, team_name)

          api.delete!(team[:id])
        rescue SemaphoreClient::Exceptions::RequestFailed
          raise Sem::Errors::ResourceNotDeleted.new("Team", [org_name, team_name])
        end

        def api
          client.teams
        end

        def to_hash(team, org)
          {
            :id => team.id,
            :name => team.name,
            :org => org,
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
