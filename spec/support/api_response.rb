module ApiResponse
  module_function

  def organization(params = {})
    {
      :id => "5bc7ed43-ac8a-487e-b488-c38bc757a034",
      :username => "rt",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)
  end

  def user(params = {})
    {
      :id => "2bc7ed43-ac8a-487e-b488-c38bc757a034",
      :username => "john-snow",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)
  end

  def team(params = {})
    {
      :id => "1bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "devs",
      :permission => "write",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)
  end

  def project(params = {})
    {
      :id => "99c7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "cli",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)
  end

  def secret(params = {})
    {
      :id => "33c7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "cli",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }.merge(params)
  end

  def file(params = {})
    {
      :id => "77c7ed43-ac8a-487e-b488-c38bc757a034",
      :path => "/var/secrets.txt",
      :encrypted => true
    }.merge(params)
  end

  def env_var(params = {})
    {
      :id => "9997ed43-ac8a-487e-b488-c38bc757a034",
      :name => "GEM_TOKEN",
      :content => "s3kr3t",
      :encrypted => true
    }.merge(params)
  end

end
