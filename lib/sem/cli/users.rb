class Sem::CLI::Users < Sem::ThorExt::SubcommandThor
  namespace "users"

  def self.instances_table(users)
    header = ["USERNAME"]

    body = users.map do |user|
      [user[:id]]
    end

    [header, *body]
  end
end
