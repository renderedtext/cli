class Sem::CLI::Users < Sem::ThorExt::SubcommandThor
  namespace "users"

  def self.instances_table(users)
    header = ["ID", "USERNAME"]

    body = users.map do |user|
      [user[:id], user[:username]]
    end

    [header, *body]
  end
end
