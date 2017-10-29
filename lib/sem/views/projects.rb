class Sem::Views::Projects < Sem::Views::Base

  def self.setup_first_project
    puts "You don't have any project configured on Semaphore."
    puts ""
    puts "Add your first project: https://semaphoreci.com/new"
    puts ""
  end

  def self.list(projects)
    header = ["ID", "NAME"]

    body = projects.map do |project|
      [project.id, project.full_name]
    end

    print_table([header, *body])
  end

  def self.info(project)
    print_table [
      ["ID", project.id],
      ["Name", project.full_name],
      ["Created", project.created_at],
      ["Updated", project.updated_at]
    ]
  end

  def self.attach_first_secrets(project)
    puts "You don't have any secrets on this project."
    puts ""
    puts "Add your first secrets:"
    puts ""
    puts "  sem projects:secrets:add #{project.full_name} SECRETS_NAME"
    puts ""
  end

end
