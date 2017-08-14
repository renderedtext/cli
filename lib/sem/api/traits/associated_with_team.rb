module Sem
  module API
    module Traits
      module AssociatedWithTeam
        def list_for_team(team_path)
          team = Teams.info(team_path)

          instances = api.list_for_team(team[:id])

          instances.map { |instance| to_hash(instance) }
        end

        def add_to_team(team_path, instance_path)
          instance = info(instance_path)
          team = Teams.info(team_path)

          api.attach_to_team(instance[:id], team[:id])
        end

        def remove_from_team(team_path, instance_path)
          instance = info(instance_path)
          team = Teams.info(team_path)

          api.detach_from_team(instance[:id], team[:id])
        end
      end
    end
  end
end
