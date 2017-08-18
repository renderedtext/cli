require "spec_helper"

describe Sem::Views::UsersWithPermissions do
  let(:user) { { :id => "ijovan", :permission => "admin" } }

  describe ".list" do
    it "shows list of users" do
      expected_value = [
        ["NAME", "PERMISSION"],
        [user[:id], user[:permission]]
      ]

      expect(described_class).to receive(:print_table).with(expected_value)

      described_class.list([user])
    end
  end
end
