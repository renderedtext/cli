class Sem::Views::SharedConfigs < Sem::Views::Base

  def self.list(configs)
    header = ["ID", "NAME"]

    body = configs.map do |config|
      [config[:id], config[:name]]
    end

    print_table [header, *body]
  end

end
