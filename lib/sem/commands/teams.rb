module Sem
  module Commands
    module Teams

      def self.run(_params)
        Sem::UI.table [
          ["ID", "NAME", "PERMISSION", "MEMBERS"],
          ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext/developers", "write", "72 members"],
          ["3333c21a-7d64-4f20-b2b1-e044607c33f6", "renderedtext/admins", "admin", "10 members"],
          ["fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", "tb-render/developers", "admin", "3 members"]
        ]
      end

    end
  end
end