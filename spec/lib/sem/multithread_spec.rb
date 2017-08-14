require "spec_helper"

describe Sem::Multithread do
  let(:input) { (1..15).to_a }

  describe ".map" do
    it "chunks the input" do
      expect(described_class).to receive(:process_chunk).with((1..10).to_a)
      expect(described_class).to receive(:process_chunk).with((11..15).to_a)

      described_class.map(input)
    end

    it "creates the threads" do
      allow(Thread).to receive(:new).and_return(Thread.new {})

      expect(Thread).to receive(:new).exactly(15).times

      described_class.map(input) {}
    end

    it "returns the results" do
      return_value = described_class.map((1..15).to_a) { |x| x * 2 }
      expected_value = (1..15).to_a.map { |x| x * 2 }

      expect(return_value).to eql(expected_value)
    end
  end
end
