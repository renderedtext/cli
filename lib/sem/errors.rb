module Sem::Errors
  Base = Class.new(StandardError)

  InvalidSRN = Class.new(StandardError)
  ResourceNotFound = Class.new(StandardError)

  module Auth
    NoCredentials = Class.new(Sem::Errors::Base)
    InvalidCredentials = Class.new(Sem::Errors::Base)
  end
end
