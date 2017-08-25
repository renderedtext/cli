class Sem::Views::Base
  class << self
    def print_table(table)
      Dracula::UI.print_table(table)
    end

    def org_names_not_matching(resource1, resource2, srn1, srn2)
      "[ERROR] Organization names not matching.\n\n" \
        "#{resource1.capitalize} \"#{srn1}\" and #{resource2} \"#{srn2}\" are not in the same organization."
    end
  end
end
