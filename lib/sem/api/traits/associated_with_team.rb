module Sem
  module API
    module Traits
      module AssociatedWithTeam
        def list_for_team(org_name, team_name)
          team_id = Teams.name_to_id(org_name, team_name)

          instances = api.list_for_team(team_id).to_a

          instances.map { |instance| to_hash(instance, org_name) }
        end

        def add_to_team(org_name, team_name, instance_name)
          instance_id = name_to_id(org_name, instance_name)
          team_id = Teams.name_to_id(org_name, team_name)

          api.attach_to_team(instance_id, team_id)
        end

        def remove_from_team(org_name, team_name, instance_name)
          instance_id = name_to_id(org_name, instance_name)
          team_id = Teams.name_to_id(org_name, team_name)

          api.detach_from_team(instance_id, team_id)
        end
      end
    end
  end
end
