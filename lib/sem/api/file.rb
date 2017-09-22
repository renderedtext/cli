class Sem::API::File < SimpleDelegator
  extend Sem::API::Base

  def encrypted?
    encrypted == true
  end
end
