class Sem::Views::Users < Sem::Views::Base

  def self.list(users)
    header = ["NAME"]

    body = users.map do |user|
      [user[:id]]
    end

    print_table [header, *body]
  end

end
