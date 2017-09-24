require "spec_helper"

describe Sem::Views::Orgs do
  let(:org1) { StubFactory.organization(:username => "rt") }
  let(:org2) { StubFactory.organization(:username => "z-fighters") }

  describe ".list" do
    it "displays a table of orgs" do
      msg = [
        "ID                                    NAME",
        "5bc7ed43-ac8a-487e-b488-c38bc757a034  rt",
        "5bc7ed43-ac8a-487e-b488-c38bc757a034  z-fighters",
        ""
      ]

      expect { Sem::Views::Orgs.list([org1, org2]) }.to output(msg.join("\n")).to_stdout
    end
  end

  describe ".info" do
    it "prints the org in table format" do
      msg = [
        "ID       5bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name     rt",
        "Created  2017-08-01 13:14:40 +0200",
        "Updated  2017-08-02 13:14:40 +0200",
        ""
      ]

      expect { Sem::Views::Orgs.info(org1) }.to output(msg.join("\n")).to_stdout
    end
  end
end
