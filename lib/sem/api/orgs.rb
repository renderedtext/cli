module Sem
  module API
    class Orgs < Base
      def self.list
        new.list
      end

      def list
        orgs = api.list

        orgs.map { |org| to_hash(org) }
      end

      private

      def api
        client.orgs
      end

      def to_hash(org)
        { :id => org.id, :username => org.username }
      end
    end
  end
end
