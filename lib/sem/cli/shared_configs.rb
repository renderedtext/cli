class Sem::CLI::SharedConfigs < Sem::ThorExt::SubcommandThor
  namespace "shared-configs"

  def self.instances_table(configs)
    header = ["ID", "NAME"]

    body = configs.map do |config|
      [config[:id], config[:name]]
    end

    [header, *body]
  end

  # desc "list", "list teams"
  # def list
  #   teams = Sem::API::Teams.list

  #   print_table(Sem::CLI::Teams.instances_table(teams))
  # end

  # desc "info", "show information about a team"
  # def info(name)
  #   team = Sem::API::Teams.info(name)

  #   print_table(Sem::CLI::Teams.instance_table(team))
  # end
end
