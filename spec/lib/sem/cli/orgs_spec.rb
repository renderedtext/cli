require "spec_helper"

describe Sem::CLI::Orgs do

  describe "#list" do
    it "lists organizations" do
      stdout, stderr = sem_run("orgs:list")

      msg = [
        "ID                                    NAME",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext",
        "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  tb-render"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#info" do
    it "shows detailed information about an organization" do
      stdout, stderr = sem_run("orgs:info renderedtext")

      msg = [
        "ID       3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name     renderedtext",
        "Created  2017-08-01 13:14:40 +0200",
        "Updated  2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

end
