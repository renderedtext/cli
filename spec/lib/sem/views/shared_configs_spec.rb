require "spec_helper"

describe Sem::Views::SharedConfigs do
  let(:shared_config1) { StubFactory.shared_config("rt", :name => "tokens") }
  let(:shared_config2) { StubFactory.shared_config("z-fighters", :name => "secrets") }

  let(:file) { StubFactory.file }
  let(:env_var) { StubFactory.env_var }

  before do
    allow(shared_config1).to receive(:files).and_return([file])
    allow(shared_config2).to receive(:files).and_return([])

    allow(shared_config1).to receive(:env_vars).and_return([])
    allow(shared_config2).to receive(:env_vars).and_return([env_var])
  end

  describe ".list" do
    it "shows list of shared configs" do
      msg = [
        "ID                                    NAME                CONFIG FILES  ENV VARS",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  rt/tokens                      1         0",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  z-fighters/secrets             0         1",
        ""
      ]

      expect { Sem::Views::SharedConfigs.list([shared_config1, shared_config2]) }.to output(msg.join("\n")).to_stdout
    end
  end

  describe ".info" do
    it "returns the config in table format" do
      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   rt/tokens",
        "Config Files           1",
        "Environment Variables  0",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200",
        ""
      ]

      expect { Sem::Views::SharedConfigs.info(shared_config1) }.to output(msg.join("\n")).to_stdout
    end
  end
end
