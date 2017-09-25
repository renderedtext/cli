class Sem::Views::SharedConfigs < Sem::Views::Base

  def self.setup_first_shared_config
    puts "You don't have any shared configurations on Semaphore."
    puts ""
    puts "Create your first shared configuration:"
    puts ""
    puts "  sem shared-config:create SHARED_CONFIG_NAME"
    puts ""
  end

  def self.list(configs)
    header = ["ID", "NAME", "CONFIG FILES", "ENV VARS"]

    body = configs.map do |config|
      [config.id, config.full_name, config.files.count, config.env_vars.count]
    end

    print_table [header, *body]
  end

  def self.info(config)
    print_table [
      ["ID", config.id],
      ["Name", config.full_name],
      ["Config Files", config.files.count.to_s],
      ["Environment Variables", config.env_vars.count.to_s],
      ["Created", config.created_at],
      ["Updated", config.updated_at]
    ]
  end

  def self.add_first_file(shared_config)
    puts "You don't have any files in this shared configuration."
    puts ""
    puts "Add your first file:"
    puts ""
    puts "  sem shared-config:files:add #{shared_config.full_name} --local-path <file> --path-on-semaphore <path>"
    puts ""
  end

  def self.add_first_env_var(shared_config)
    puts "You don't have any environment variable in this shared configuration."
    puts ""
    puts "Add your first environment variable:"
    puts ""
    puts "  sem shared-config:env-vars:add #{shared_config.full_name} --local-path <file> --path-on-semaphore <path>"
    puts ""
  end

end
