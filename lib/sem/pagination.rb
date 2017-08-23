module Sem
  class Pagination
    class << self
      def pages(pages_per_call, &block)
        instances = []
        index = 1

        loop do
          pages = range_map(index, pages_per_call, &block)

          instances += pages.select { |page| !(page.nil? || page.empty?) }
          index += pages_per_call

          break instances if pages.any? { |page| page.nil? || page.empty? }
        end
      end

      private

      def range_map(start_index, pages_per_call)
        end_index = start_index + pages_per_call - 1

        (start_index..end_index).to_a.pmap do |page_index|
          yield(page_index)
        end
      end
    end
  end
end
