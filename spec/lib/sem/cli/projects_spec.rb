require "spec_helper"

describe Sem::CLI::Projects do
  let(:project) { { :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034", :name => "renderedtext/cli" } }

  describe ".instances_table" do
    it "returns the projects in table format" do
      return_value = described_class.instances_table([project])

      expected_value = [
        ["ID", "NAME"],
        [project[:id], project[:name]]
      ]

      expect(return_value).to eql(expected_value)
    end
  end
end
