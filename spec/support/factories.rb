module StubFactory
  module_function

  def organization
    RSpec::Mocks::Double.new(Sem::API::Org,
                             :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
                             :username => "rt",
                             :created_at => "2017-08-01 13:14:40 +0200",
                             :updated_at => "2017-08-02 13:14:40 +0200")
  end

  def user
    RSpec::Mocks::Double.new(Sem::API::User,
                             :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
                             :username => "john-snow",
                             :created_at => "2017-08-01 13:14:40 +0200",
                             :updated_at => "2017-08-02 13:14:40 +0200")
  end

  def team
    RSpec::Mocks::Double.new(Sem::API::Team,
                             :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
                             :name => "devs",
                             :org => "rt",
                             :permission => "write",
                             :created_at => "2017-08-01 13:14:40 +0200",
                             :updated_at => "2017-08-02 13:14:40 +0200")
  end

  def project
    RSpec::Mocks::Double.new(Sem::API::Project,
                             :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
                             :name => "cli",
                             :org => "rt",
                             :created_at => "2017-08-01 13:14:40 +0200",
                             :updated_at => "2017-08-02 13:14:40 +0200")
  end

  def shared_config
    RSpec::Mocks::Double.new(Sem::API::SharedConfig,
                             :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
                             :name => "cli",
                             :org => "rt",
                             :created_at => "2017-08-01 13:14:40 +0200",
                             :updated_at => "2017-08-02 13:14:40 +0200")
  end

  def file
    RSpec::Mocks::Double.new(Sem::API::File)
  end

  def env_var
    RSpec::Mocks::Double.new(Sem::API::EnvVar)
  end

end
