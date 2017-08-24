module Sem
  module API
    class Orgs < Base
      class << self
        def list
          orgs = api.list

          orgs.map { |org| to_hash(org) }
        end

        def info(name)
          org = api.get(name)

          raise_not_found("Organization", [name]) if org.nil?

          to_hash(org)
        end

        def list_teams(name)
          Sem::API::Teams.list_for_org(name)
        end

        def list_users(name)
          Sem::API::Users.list_for_org(name)
        end

        def list_admins(name)
          admin_teams = list_teams(name).select { |team| team[:permission] == "admin" }

          admins = admin_teams.map { |team| client.users.list_for_team(team[:id]).to_a }.flatten

          admins.map { |admin| Sem::API::Users.to_hash(admin) }
        end

        def list_owners(name)
          owners_team = list_teams(name).find { |team| team[:name] == "Owners" }

          owners = client.users.list_for_team(Hash[owners_team.to_a][:id]).to_a

          owners.map { |owner| Sem::API::Users.to_hash(owner) }
        end

        def api
          client.orgs
        end

        def to_hash(org)
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
end
