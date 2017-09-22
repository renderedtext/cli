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

  def self.attach_first_shared_config(project)
    puts "You don't have any shared configurations on this project."
    puts ""
    puts "Add your first shared configuration:"
    puts ""
    puts "  sem projects:shared-configs:add #{project.full_name} SHARED_CONFIG_NAME"
    puts ""
  end

end
