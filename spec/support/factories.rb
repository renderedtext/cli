module StubFactory
  module_function

  def organization(params = {})
    api_response = ApiResponse.organization(params)
    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::Org, api_response)

    Sem::API::Org.new(api_model)
  end

  def user(params = {})
    api_response = ApiResponse.user(params)
    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::User, api_response)

    Sem::API::User.new(api_model)
  end

  def team(org_name, params = {})
    api_response = ApiResponse.team(params)
    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::Team, api_response)

    Sem::API::Team.new(org_name, api_model)
  end

  def project(org_name, params = {})
    api_response = ApiResponse.project(params)
    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::Project, api_response)

    Sem::API::Project.new(org_name, api_model)
  end

  def secret(org_name, params = {})
    api_response = ApiResponse.project(params)
    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::SharedConfig, api_response)

    Sem::API::Secret.new(org_name, api_model)
  end

  def file(params = {})
    api_response = ApiResponse.file(params)
    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::ConfigFile, api_response)

    Sem::API::File.new(api_model)
  end

  def env_var(params = {})
    api_response = ApiResponse.env_var(params)
    api_model = RSpec::Mocks::Double.new(SemaphoreClient::Model::EnvVar, api_response)

    Sem::API::EnvVar.new(api_model)
  end

end
