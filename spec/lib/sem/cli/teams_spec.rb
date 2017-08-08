require "spec_helper"

describe Sem::CLI::Teams do

  describe "#list" do
    it "lists the teams" do
      stdout, stderr = sem_run("teams:list")

      msg = [
        "ID                                    NAME                     PERMISSION  MEMBERS",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/developers  write       72 members",
        "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  tb-render/developers     admin       3 members"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#info" do
  end

  describe "#create" do
  end

  describe "#update" do
  end

  describe "#delete" do
  end

end
