class Sem::Views::Secrets < Sem::Views::Base

  def self.setup_first_secrets
    puts "You don't have any secrets on Semaphore."
    puts ""
    puts "Create your first secrets:"
    puts ""
    puts "  sem secrets:create SECRETS_NAME"
    puts ""
  end

  def self.list(secrets)
    header = ["ID", "NAME", "CONFIG FILES", "ENV VARS"]

    body = secrets.pmap do |secret|
      [secret.id, secret.full_name, secret.files.count, secret.env_vars.count]
    end

    print_table [header, *body]
  end

  def self.info(secret)
    print_table [
      ["ID", secret.id],
      ["Name", secret.full_name],
      ["Config Files", secret.files.count.to_s],
      ["Environment Variables", secret.env_vars.count.to_s],
      ["Created", secret.created_at],
      ["Updated", secret.updated_at]
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
    puts "  sem secrets:env-vars:add #{secret.full_name} --local-path <file> --path-on-semaphore <path>"
    puts ""
  end

end
