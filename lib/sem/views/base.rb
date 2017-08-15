class Sem::Views::Base

  def self.print_table(table)
    Thor::Shell::Basic.new.print_table(table)
  end

end
