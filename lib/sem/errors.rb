module Sem::Errors
  Base = Class.new(StandardError)

  InvalidSRN = Class.new(StandardError)
  InvalidParameter = Class.new(StandardError)
  OrgNamesNotMatching = Class.new(StandardError)

  module Resource
    Base = Class.new(StandardError)

    NotFound = Class.new(Base)
    NotCreated = Class.new(Base)
    NotUpdated = Class.new(Base)
  end

  module Auth
    NoCredentials = Class.new(Sem::Errors::Base)
    InvalidCredentials = Class.new(Sem::Errors::Base)
  end
end
