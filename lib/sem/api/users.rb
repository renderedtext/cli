module Sem
  module API
    class Users < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      class << self
        def list
          org_names = Orgs.list.map { |org| org[:username] }

          org_names.map { |name| list_for_org(name) }.flatten
        end

        def info(*args)
          name = args.count == 2 ? args[1] : args[0]

          selected_user = list.find { |user| user[:id] == name }

          raise_not_found([name]) if selected_user.nil?

          selected_user
        end

        def api
          client.users
        end

        def to_hash(user)
          { :id => user.username }
        end
      end
    end
  end
end
