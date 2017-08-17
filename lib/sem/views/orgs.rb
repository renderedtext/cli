class Sem::Views::Orgs < Sem::Views::Base

  def self.list(orgs)
    header = ["ID", "NAME"]

    body = orgs.map do |org|
      [org[:id], org[:name]]
    end

    print_table [header, *body]
  end

  def self.info(org)
    print_table [
      ["ID", org[:id]],
      ["Name", org[:name]],
      ["Created", org[:created_at]],
      ["Updated", org[:updated_at]]
    ]
  end

end
