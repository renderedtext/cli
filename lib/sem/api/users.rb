module Sem
  module API
    class Users < Base
      extend Traits::AssociatedWithOrg
      extend Traits::AssociatedWithTeam

      class << self
        def list
          org_names = Orgs.list.map { |org| org[:username] }

          org_names.pmap { |name| list_for_org(name) }.flatten
        end

        def info(*args)
          if args.count == 2
            org_name, user_name = args
            users = list_for_org(org_name)
          else
            user_name = args.first
            users = list
          end

          selected_user = users.find { |user| user[:id] == user_name }

          raise_not_found("User", [user_name]) if selected_user.nil?

          selected_user
        end

        def api
          client.users
        end

        def to_hash(user, _ = nil)
          { :id => user.username }
        end
      end
    end
  end
end
