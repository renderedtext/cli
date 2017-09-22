class Sem::API::User < SimpleDelegator
  extend Base

  def self.all
    client.users.list(:auto_paginate => true).map { |user| new(user) }
  end

end
