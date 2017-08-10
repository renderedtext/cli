module Sem
  module API
    class Configs < Base
      def self.list
        new.list
      end

      def self.list_for_org(org_name)
        new.list_for_org(org_name)
      end

      def self.list_for_team(team_path)
        new.list_for_team(team_path)
      end

      def self.info(name)
        new.info(name)
      end

      def self.add_to_team(team_path, config_path)
        new.add_to_team(team_path, config_path)
      end

      def self.remove_from_team(team_path, config_path)
        new.remove_from_team(team_path, config_path)
      end

      def list
        org_names = Orgs.list.map { |org| org[:username] }

        org_names.map { |name| list_for_org(name) }.flatten
      end

      def list_for_org(org_name)
        configs = api.list_for_org(org_name)

        configs.map { |config| to_hash(config) }
      end

      def list_for_team(team_path)
        team = Teams.info(team_path)

        configs = api.list_for_team(team[:id])

        configs.map { |config| to_hash(config) }
      end

      def info(path)
        org_name, config_name = path.split("/")

        list_for_org(org_name).find { |config| config[:name] == config_name }
      end

      def add_to_team(team_path, config_path)
        config = info(config_path)
        team = Teams.info(team_path)

        api.attach_to_team(config[:id], team[:id])
      end

      def remove_from_team(team_path, config_path)
        config = info(config_path)
        team = Teams.info(team_path)

        api.detach_from_team(config[:id], team[:id])
      end

      private

      def api
        client.shared_configs
      end

      def to_hash(configs)
        {
          :id => configs.id,
          :name => configs.name
        }
      end
    end
  end
end
