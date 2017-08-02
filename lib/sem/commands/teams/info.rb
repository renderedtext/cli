module Sem
  module Commands
    module Teams
      module Info

        def self.run(params)
          name = params.shift

          if name == "renderedtext/developers"
            Sem::UI.show_hash(
              "ID" => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
              "Name" => "renderedtext/developers",
              "Permission" => "write",
              "Members" => "72 members",
              "Created" => "2017-08-01 13:14:40 +0200",
              "Updated" => "2017-08-02 13:14:40 +0200"
            )
          else
            Sem::UI.error "Couldn't find that team."
          end
        end

      end
    end
  end
end
