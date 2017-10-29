class Sem::Views::Secrets < Sem::Views::Base

  def self.setup_first_secrets
    puts "You don't have any secrets on Semaphore."
    puts ""
    puts "Create your first secrets:"
    puts ""
    puts "  sem secrets:create SECRETS_NAME"
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

  def self.add_first_file(secret)
    puts "You don't have any files in these secrets"
    puts ""
    puts "Add your first file:"
    puts ""
    puts "  sem secrets:files:add #{secret.full_name} --local-path <file> --path-on-semaphore <path>"
    puts ""
  end

  def self.add_first_env_var(secret)
    puts "You don't have any environment variable in these secrets"
    puts ""
    puts "Add your first environment variable:"
    puts ""
    puts "  sem secrets:env-vars:add #{secrets.full_name} --local-path <file> --path-on-semaphore <path>"
    puts ""
  end

end
