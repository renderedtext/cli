module Sem
  module API
    module Traits
      module AssociatedWithTeam
        def list_for_team(org_name, team_name)
          team = Teams.info(org_name, team_name)

          instances = api.list_for_team(team[:id])

          instances.map { |instance| to_hash(instance) }
        end

        def add_to_team(org_name, team_name, instance_name)
          instance = info(org_name, instance_name)
          team = Teams.info(org_name, team_name)

          api.attach_to_team(instance[:id], team[:id])
        end

        def remove_from_team(org_name, team_name, instance_name)
          instance = info(org_name, instance_name)
          team = Teams.info(org_name, team_name)

          api.detach_from_team(instance[:id], team[:id])
        end
      end
    end
  end
end
