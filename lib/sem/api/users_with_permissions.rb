module Sem
  module API
    class UsersWithPermissions < Base
      class << self
        LEVELS = { "owner" => 3, "admin" => 2, "write" => 1, "read" => 0 }.freeze

        def list_owners_for_org(org_name)
          Sem::API::Orgs.list_owners(org_name).map { |user| user.merge(:permission => "owner") }
        end

        def list_admins_for_org(org_name)
          Sem::API::Orgs.list_admins(org_name).map { |user| user.merge(:permission => "admin") }
        end

        def list_for_org(org_name)
          all_teams = client.teams.list_for_org(org_name)

          team_groups = teams_by_permission(all_teams)

          user_groups = users_for_team_groups(team_groups)

          user_groups.reduce({}) { |acc, teams| acc.merge(teams) }.values
        end

        private

        def teams_by_permission(all_teams)
          groups = all_teams.group_by(&:permission)

          groups.sort_by { |permission, _| LEVELS[permission] }.to_h.values
        end

        def users_for_team_groups(groups)
          Multithread.map(groups) { |teams| users_for_teams(teams) }.flatten
        end

        def users_for_teams(teams)
          Multithread.map(teams) { |team| users_for_team(team) }.flatten.uniq
        end

        def users_for_team(team)
          users = client.users.list_for_team(team.id)

          users.map { |user| [user.username, transform_user(user, team)] }.to_h
        end

        def transform_user(user, team)
          Users.to_hash(user).merge(:permission => team.permission)
        end
      end
    end
  end
end
