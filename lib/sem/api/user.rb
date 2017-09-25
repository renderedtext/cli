class Sem::API::User < SimpleDelegator
  extend Sem::API::Base

  def self.all
    client.users.list.map { |user| new(user) }
  end

end
