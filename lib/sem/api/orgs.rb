module Sem
  module API
    class Orgs < Base
      class << self
        def list
          orgs = api.list

          orgs.to_a.map { |org| to_hash(org) }
        end

        def info(name)
          org = api.get(name)

          raise Sem::Errors::ResourceNotFound.new("Organization", [name]) if org.nil?

          to_hash(org)
        end

        def list_teams(name)
          Sem::API::Teams.list_for_org(name)
        end

        def list_users(name)
          Sem::API::Users.list_for_org(name)
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
