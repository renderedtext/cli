require "spec_helper"

describe Sem::Views::SharedConfigs do
  let(:shared_config) do
    {
      :id => "8026c34e-0fcb-45c1-acb0-2cec38cd0068",
      :name => "tokens",
      :config_files => 1,
      :env_vars => 2
    }
  end

  describe ".list" do
    it "shows list of shared configs" do
      expected_value = [
        ["ID", "NAME", "CONFIG FILES", "ENV VARS"],
        [shared_config[:id], shared_config[:name], shared_config[:config_files], shared_config[:env_vars]]
      ]

      expect(Sem::Views::SharedConfigs).to receive(:print_table).with(expected_value)

      described_class.list([shared_config])
    end
  end
end
