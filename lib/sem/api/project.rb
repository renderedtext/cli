class Sem::API::Project < SimpleDelegator
  extend Sem::API::Base

  def self.all
    Sema::API::Org.all.map do |org|
      client.projects.list_for_org(org.name).map { |project| new(project) }
    end.flatten
  end

  def self.find!(project_srn)
    org_name, project_name = Sem::SRN.parse_project(project_srn)    

    project = client.projects.list_for_org(org_name, :name => project_name).first

    raise Sem::Errors::ResourceNotFound.new("Project", [org_name, project_name]) if project.nil?

    new(org_name, project)
  end

  attr_reader :org_name

  def initialize(org_name, project)
    @org_name = org_name

    super(project)
  end

  def full_name
    "#{@org_name}/#{name}"
  end

  def teams
    client.teams.list_for_project(id).map { |team| Sem::API::Team.new(org_name, team) }
  end

  def users

  end

  def files

  end

  def env_vars

  end

end
