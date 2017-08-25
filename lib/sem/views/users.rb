class Sem::Views::Users < Sem::Views::Base
  class << self
    def list(users)
      header = ["NAME"]

      body = users.map { |user| [user[:id]] }

      print_table [header, *body]
    end
  end
end
