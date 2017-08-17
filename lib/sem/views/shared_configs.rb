class Sem::Views::SharedConfigs < Sem::Views::Base

  def self.list(configs)
    header = ["ID", "NAME", "CONFIG FILES", "ENV VARS"]

    body = configs.map do |config|
      [config[:id], config[:name], config[:config_files], config[:env_vars]]
    end

    print_table [header, *body]
  end

end
