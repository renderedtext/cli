class Sem::Views::EnvVars < Sem::Views::Base

  def self.list(env_vars)
    header = ["ID", "NAME", "ENCRYPTED?", "CONTENT"]

    body = env_vars.map do |env_var|
      [env_var[:id], env_var[:name], env_var[:encrypted?], env_var[:content]]
    end

    print_table([header, *body])
  end

end
