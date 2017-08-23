module Sem::Errors
  Base = Class.new(StandardError)

  InvalidSRN = Class.new(StandardError)

  module Resource
    NotFound = Class.new(StandardError)
  end

  module Auth
    NoCredentials = Class.new(Sem::Errors::Base)
    InvalidCredentials = Class.new(Sem::Errors::Base)
  end
end
