require "spec_helper"

describe Sem::Views::SharedConfigs do
  let(:shared_config) do
    {
      :id => "8026c34e-0fcb-45c1-acb0-2cec38cd0068",
      :name => "tokens",
      :config_files => 1,
      :env_vars => 2,
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
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

  describe ".info" do
    it "returns the config in table format" do
      table = [
        ["ID", "8026c34e-0fcb-45c1-acb0-2cec38cd0068"],
        ["Name", "tokens"],
        ["Config Files", "1"],
        ["Environment Variables", "2"],
        ["Created", "2017-08-01 13:14:40 +0200"],
        ["Updated", "2017-08-02 13:14:40 +0200"]
      ]

      expect(Sem::Views::SharedConfigs).to receive(:print_table).with(table)

      described_class.info(shared_config)
    end
  end
end
