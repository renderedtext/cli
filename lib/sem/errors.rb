module Sem::Errors
  Base = Class.new(StandardError)

  module Auth
    NoCredentils = Class.new(Sem::Errors::Base)
    InvalidCredentils = Class.new(Sem::Errors::Base)
  end
end
