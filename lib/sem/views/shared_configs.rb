class Sem::Views::SharedConfigs < Sem::Views::Base

  def self.list(configs)
    if configs.empty?
      puts "You don't have any shared configurations on Semaphore."
      puts ""
      puts "Create your first shared configuration:"
      puts ""
      puts "  sem shared-config:create ORG_NAME/SHARED_CONFIG"
      puts ""

      return
    end

    header = ["ID", "NAME", "CONFIG FILES", "ENV VARS"]

    body = configs.map do |config|
      [config[:id], config[:name], config[:config_files], config[:env_vars]]
    end

    print_table [header, *body]
  end

  def self.info(config)
    print_table [
      ["ID", config[:id]],
      ["Name", config[:name]],
      ["Config Files", config[:config_files].to_s],
      ["Environment Variables", config[:env_vars].to_s],
      ["Created", config[:created_at]],
      ["Updated", config[:updated_at]]
    ]
  end

end
