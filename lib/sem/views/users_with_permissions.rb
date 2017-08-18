class Sem::Views::UsersWithPermissions < Sem::Views::Base

  def self.list(users)
    header = ["NAME", "PERMISSION"]

    body = users.map do |user|
      [user[:id], user[:permission]]
    end

    print_table [header, *body]
  end

end
