module Sem::Errors
  Base = Class.new(StandardError)

  InvalidPath = Class.new(Sem::Errors::Base)

  module Auth
    NoCredentials = Class.new(Sem::Errors::Base)
    InvalidCredentials = Class.new(Sem::Errors::Base)
  end
end
