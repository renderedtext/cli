class Sem::Views::Base
  class << self
    def print_table(table)
      Dracula::UI.print_table(table)
    end

    def org_names_not_matching
      "[ERROR] Organization names not matching.\n" \
      "\n" \
      "Resource manipulation is only possible within the same organization."
    end
  end
end
