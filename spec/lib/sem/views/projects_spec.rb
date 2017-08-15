require "spec_helper"

describe Sem::Views::Projects do
  let(:project) { { :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034", :name => "renderedtext/cli" } }

  describe ".list" do
    it "returns the projects in table format" do
      expected_value = [
        ["ID", "NAME"],
        [project[:id], project[:name]]
      ]

      expect(Sem::Views::Projects).to receive(:print_table).with(expected_value)

      described_class.list([project])
    end
  end
end
