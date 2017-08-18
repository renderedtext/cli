module Sem::Errors
  Base = Class.new(StandardError)

  module Auth
    NoCredentials = Class.new(Sem::Errors::Base)
    InvalidCredentials = Class.new(Sem::Errors::Base)
  end
end
