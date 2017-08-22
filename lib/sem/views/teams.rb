class Sem::Views::Teams < Sem::Views::Base

  def self.list(teams)
    header = ["ID", "NAME", "PERMISSION", "MEMBERS"]

    body = teams.map do |team|
      [team[:id], "#{team[:org]}/#{team[:name]}", team[:permission], "#{team[:members]} members"]
    end

    print_table [header, *body]
  end

  def self.info(team)
    print_table [
      ["ID", team[:id]],
      ["Name", "#{team[:org]}/#{team[:name]}"],
      ["Permission", team[:permission]],
      ["Members", "#{team[:members]} members"],
      ["Created", team[:created_at]],
      ["Updated", team[:updated_at]]
    ]
  end

end
