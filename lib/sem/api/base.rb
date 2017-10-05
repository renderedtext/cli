module Sem::API::Base
  module_function

  def client
    @client ||= create_api_client(
      Sem::Configuration.api_url,
      Sem::Configuration.auth_token)
  end

  def create_new_api_client(api_url, auth_token)
    SemaphoreClient.new(auth_token, :api_url => api_url,
                                    :logger => api_logger,
                                    :auto_paginate => true)
  end

  def api_logger
    return nil unless Sem.trace?
    return @api_logger if defined?(@api_logger)

    @api_logger = Logger.new(STDOUT)
    @api_logger.level = Logger::DEBUG

    @api_logger
  end

end
