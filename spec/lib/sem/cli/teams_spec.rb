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
    it "shows information about a team" do
      stdout, stderr = sem_run("teams:info renderedtext/developers")

      msg = [
        "ID          3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        renderedtext/developers",
        "Permission  write",
        "Members     72 members",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
    end
  end

  describe "#create" do
    it "creates a team and displays it" do
      stdout, stderr = sem_run("teams:create renderedtext/new-developers --permission write")

      msg = [
        "ID          3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        renderedtext/new-developers",
        "Permission  write",
        "Members     0 members",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
    end
  end

  describe "#update" do
    it "updates the team" do
      stdout, stderr = sem_run("teams:update renderedtext/developers --name renderedtext/admins --permission admin")

      msg = [
        "ID          3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        renderedtext/admins",
        "Permission  admin",
        "Members     4 members",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
    end
  end

  describe "#delete" do
    it "deletes the team" do
      stdout, stderr = sem_run("teams:delete renderedtext/old-developers")

      msg = [
        "Deleted team renderedtext/old-developers"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
    end
  end

end
