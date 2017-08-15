require "spec_helper"

describe Sem::Views::Users do
  let(:user) { { :id => "ijovan" } }

  describe ".list" do
    it "shows list of users" do
      expected_value = [
        ["USERNAME"],
        [user[:id]]
      ]

      expect(Sem::Views::Users).to receive(:print_table).with(expected_value)

      described_class.list([user])
    end
  end
end
