require "spec_helper"

describe Sem::CLI::Users do
  let(:user) { { :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034", :username => "ijovan" } }

  describe ".users_table" do
    it "returns the users in table format" do
      return_value = described_class.users_table([user])

      expected_value = [
        ["ID", "USERNAME"],
        [user[:id], user[:username]]
      ]

      expect(return_value).to eql(expected_value)
    end
  end
end
