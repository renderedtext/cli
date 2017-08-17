class Sem::Views::Files < Sem::Views::Base

  def self.list(files)
    header = ["ID", "NAME", "ENCRYPTED?"]

    body = files.map do |file|
      [file[:id], file[:name], file[:encrypted?]]
    end

    print_table([header, *body])
  end

end
