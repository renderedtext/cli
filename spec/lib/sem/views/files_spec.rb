require "spec_helper"

describe Sem::Views::Files do
  let(:file) { { :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034", :name => "renderedtext/cli", :encrypted? => true } }

  describe ".list" do
    it "returns the files in table format" do
      expected_value = [
        ["ID", "NAME", "ENCRYPTED?"],
        [file[:id], file[:name], file[:encrypted?]]
      ]

      expect(Sem::Views::Files).to receive(:print_table).with(expected_value)

      described_class.list([file])
    end
  end
end
