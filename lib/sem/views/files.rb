class Sem::Views::Files < Sem::Views::Base

  def self.list(files)
    header = ["ID", "PATH", "ENCRYPTED?"]

    body = files.map do |file|
      [file.id, file.path, file.encrypted?]
    end

    print_table([header, *body])
  end

end
