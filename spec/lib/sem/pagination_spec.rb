require "spec_helper"

describe Sem::Pagination do
  describe ".pages" do
    let(:hash) { { "1" => [1] } }

    it "stops after it reaches an empty page" do
      expect(hash).to receive(:[]).with("1").and_call_original
      expect(hash).to receive(:[]).with("2").and_call_original

      described_class.pages(1) do |index|
        hash[index.to_s]
      end
    end

    it "returns the pages" do
      return_value = described_class.pages(2) do |index|
        hash[index.to_s]
      end

      expect(return_value).to eql([[1]])
    end
  end
end
