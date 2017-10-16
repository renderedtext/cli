class Sem::Views::EnvVars < Sem::Views::Base

  def self.list(env_vars)
    header = ["ID", "NAME", "ENCRYPTED?", "CONTENT"]

    body = env_vars.map do |var|
      content = var.encrypted? ? "*encrypted*" : var.content

      [var.id, var.name, var.encrypted?, content]
    end

    print_table([header, *body])
  end

end
