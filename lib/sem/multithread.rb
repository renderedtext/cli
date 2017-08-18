module Sem
  class Multithread
    MAX_THREADS = 10

    class << self
      def map(array, &block)
        chunks = array.each_slice(MAX_THREADS).to_a

        chunks.flat_map { |chunk| process_chunk(chunk, &block) }
      end

      private

      def process_chunk(array)
        threads = array.map do |element|
          Thread.new { Thread.current[:output] = yield(element) }
        end

        threads.map do |thread|
          thread.join

          thread[:output]
        end
      end
    end
  end
end
