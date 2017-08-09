require "spec_helper"

describe Sem::CLI::Teams do
  let(:team) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "renderedtext/developers",
      :permission => "write",
      :members => "72",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    let(:another_team) do
      {
        :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0",
        :name => "tb-render/developers",
        :permission => "admin",
        :members => "3"
      }
    end

    before { allow(Sem::API::Teams).to receive(:list).and_return([team, another_team]) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:list)

      sem_run("teams:list")
    end

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
    before { allow(Sem::API::Teams).to receive(:info).and_return(team) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:info).with("renderedtext/developers")

      sem_run("teams:info renderedtext/developers")
    end

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
    before { allow(Sem::API::Teams).to receive(:create).and_return(team) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:create).with("renderedtext", :name => "developers", :permission => "write")

      sem_run("teams:create renderedtext/developers --permission write")
    end

    it "creates a team and displays it" do
      stdout, stderr = sem_run("teams:create renderedtext/developers --permission write")

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
    before { allow(Sem::API::Teams).to receive(:delete) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:delete).with("renderedtext/old-developers")

      sem_run("teams:delete renderedtext/old-developers")
    end

    it "deletes the team" do
      stdout, stderr = sem_run("teams:delete renderedtext/old-developers")

      msg = [
        "Deleted team renderedtext/old-developers"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
    end
  end

  describe "#members" do
    it "lists team members" do
      stdout, stderr = sem_run("teams:members renderedtext/developers")
    end
  end

  describe "#add_member" do
    it "add a user to the team" do
      stdout, stderr = sem_run("teams:add-member renderedtext/developers ijovan")
    end
  end

  describe "#remove_member" do
    it "removes a user from the team" do
      stdout, stderr = sem_run("teams:remove-member renderedtext/developers ijovan")
    end
  end

  describe "#projects" do
    it "lists projects in the team" do
      stdout, stderr = sem_run("teams:projets renderedtext/developers")
    end
  end

  describe "#add_project" do
    it "removes a project from the team" do
      stdout, stderr = sem_run("teams:add-project renderedtext/developers renderedtext/cli")
    end
  end

  describe "#remove_project" do
    it "removes a project from the team" do
      stdout, stderr = sem_run("teams:remove-project renderedtext/developers renderedtext/cli")
    end
  end

  describe "#configs" do
    it "lists shared configurations in the team" do
      stdout, stderr = sem_run("teams:configs renderedtext/developers")
    end
  end

  describe "#add_config" do
    it "add a shared configuration to the team" do
      stdout, stderr = sem_run("teams:add-config renderedtext/developers renderedtext/aws-tokens")
    end
  end

  describe "#remove_config" do
    it "removes a shared configuration from the team" do
      stdout, stderr = sem_run("teams:remove-config renderedtext/developers renderedtext/aws-tokens")
    end
  end

end
