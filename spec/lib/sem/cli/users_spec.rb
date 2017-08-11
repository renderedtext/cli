require "spec_helper"

describe Sem::CLI::Users do
  let(:user) { { :id => "ijovan" } }

  describe ".instances_table" do
    it "returns the users in table format" do
      return_value = described_class.instances_table([user])

      expected_value = [
        ["USERNAME"],
        [user[:id]]
      ]

      expect(return_value).to eql(expected_value)
    end
  end
end
