require "spec_helper"

describe Sem::Views::SharedConfigs do
  let(:shared_config) { { :id => "8026c34e-0fcb-45c1-acb0-2cec38cd0068", :name => "tokens" } }

  describe ".list" do
    it "shows list of shared configs" do
      expected_value = [
        ["ID", "NAME"],
        [shared_config[:id], shared_config[:name]]
      ]

      expect(Sem::Views::SharedConfigs).to receive(:print_table).with(expected_value)

      described_class.list([shared_config])
    end
  end
end
