class Sem::API::EnvVar < SimpleDelegator
  extend Sem::API::Base

  def encrypted?
    encrypted == true
  end
end
