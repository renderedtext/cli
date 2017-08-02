module Sem
  module Commands
    module Login

      def self.run(_params)
        print "Username: "
        username = STDIN.gets

        print "Password: "
        STDIN.gets

        Sem::UI.info ""
        Sem::UI.info "Thanks! #{username}"
        Sem::UI.info ""
        Sem::UI.info "Now please go to https://semaphoreci.com/users/edit,"
        Sem::UI.info "fetch your auth token and put it in the ~/.sem/credentials file."
        Sem::UI.info ""
        Sem::UI.info ":troll:"
      end

    end
  end
end
