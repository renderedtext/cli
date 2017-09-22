module Sem::API::Base

  def self.client
    return nil if ENV["__CLI_TEST"]

    @client ||= SemaphoreClient.new(
      Sem::Configuration.auth_token,
      :api_url => Sem::Configuration.api_url,
      :verbose => (Sem.log_level == Sem::LOG_LEVEL_TRACE),
      :auto_paginate => true
    )
  end

end
