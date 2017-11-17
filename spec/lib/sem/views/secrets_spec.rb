require "spec_helper"

describe Sem::Views::Secrets do
  let(:secret1) { StubFactory.secret("rt", :name => "tokens") }
  let(:secret2) { StubFactory.secret("z-fighters", :name => "tokens") }

  let(:file) { StubFactory.file }
  let(:env_var) { StubFactory.env_var }

  before do
    allow(secret1).to receive(:files).and_return([file])
    allow(secret2).to receive(:files).and_return([])

    allow(secret1).to receive(:env_vars).and_return([])
    allow(secret2).to receive(:env_vars).and_return([env_var])
  end

  describe ".list" do
    it "shows list of secrets" do
      msg = [
        "ID                                    NAME               CONFIG FILES  ENV VARS",
        "99c7ed43-ac8a-487e-b488-c38bc757a034  rt/tokens                     1         0",
        "99c7ed43-ac8a-487e-b488-c38bc757a034  z-fighters/tokens             0         1",
        ""
      ]

      expect { Sem::Views::Secrets.list([secret1, secret2]) }.to output(msg.join("\n")).to_stdout
    end
  end

  describe ".info" do
    it "returns the secret in table format" do
      msg = [
        "ID                     99c7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   rt/tokens",
        "Config Files           1",
        "Environment Variables  0",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200",
        ""
      ]

      expect { Sem::Views::Secrets.info(secret1) }.to output(msg.join("\n")).to_stdout
    end
  end
end
