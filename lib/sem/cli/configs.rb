class Sem::CLI::Configs < Sem::ThorExt::SubcommandThor
  namespace "configs"

  def self.instances_table(configs)
    header = ["ID", "NAME"]

    body = configs.map do |config|
      [config[:id], config[:name]]
    end

    [header, *body]
  end
end
