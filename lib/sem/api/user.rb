class Sem::API::User < SimpleDelegator
  extend Base

  def self.all
    client.users.list.map { |user| new(user) }
  end

end
