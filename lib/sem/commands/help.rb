module Sem
  module Commands
    module Help

      def self.run(_params)
        Sem::UI.info "Usage: sem COMMAND"
        Sem::UI.info ""

        Sem::UI.info "Help topics, type #{Sem::UI.strong "sem help TOPIC"} for more details:"
        Sem::UI.info ""

        Sem::UI.table [
          ["  teams", "manage teams and team membership"],
          ["  projects", "manage projects"],
          ["  orgs", "manage organizations"]
        ]

        Sem::UI.info ""
      end

    end
  end
end
