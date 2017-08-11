module Sem
  module API
    class Orgs < Base
      def self.list
        orgs = api.list

        orgs.map { |org| to_hash(org) }
      end

      def self.api
        client.orgs
      end

      def self.to_hash(org)
        { :id => org.id, :username => org.username }
      end
    end
  end
end
