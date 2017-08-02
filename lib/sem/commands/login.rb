module Sem
  module Commands
    module Login

      def self.run(_params)
        username  = Sem::UI.ask("Username")
        _password = Sem::UI.ask("Password", :hidden => true)

        Sem::UI.info ""
        Sem::UI.info ""
        Sem::UI.info "Thanks #{username}!"
        Sem::UI.info ""
        Sem::UI.info "Now please go to https://semaphoreci.com/users/edit,"
        Sem::UI.info "fetch your auth token and put it in the ~/.sem/credentials file."
        Sem::UI.info ""
        Sem::UI.info ":troll:"
      end

    end
  end
end
