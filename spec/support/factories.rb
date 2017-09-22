module StubFactory
  module_function

  def organization(params = {})
    params = {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :username => "rt",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)

    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::Org, params)

    Sem::API::Org.new(api_model)
  end

  def user(params = {})
    params = {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :username => "john-snow",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)

    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::User, params)

    Sem::API::User.new(api_model)
  end

  def team(org_name = "rt", params = {})
    params = {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "devs",
      :permission => "write",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)

    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::Team, params)

    Sem::API::Team.new(org_name, api_model)
  end

  def project(org_name = "rt", params = {})
    params = {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "cli",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)

    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::Project, params)

    Sem::API::Project.new(org_name, api_model)
  end

  def shared_config(org_name = "rt", params = {})
    params = {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "cli",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)

    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::SharedConfig, params)

    Sem::API::SharedConfig.new(org_name, api_model)
  end

  def file(params = {})
    params = {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :path => "/var/secrets.txt",
      :encrypted => true
    }.merge(params)

    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::ConfigFile, params)

    Sem::API::File.new(api_model)
  end

  def env_var(params = {})
    params = {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "GEM_TOKEN",
      :content => "s3kr3t",
      :encrypted => true
    }.merge(params)

    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::EnvVar, params)

    Sem::API::EnvVar.new(api_model)
  end

end
