require "spec_helper"

describe Sem::CLI::Projects do
  let(:project) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "renderedtext/cli",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    let(:another_project) { { :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", :name => "tb-render/api" } }

    before { allow(Sem::API::Projects).to receive(:list).and_return([project, another_project]) }

    it "calls the API" do
      expect(Sem::API::Projects).to receive(:list)

      sem_run("projects:list")
    end

    it "lists projects" do
      stdout, stderr = sem_run("projects:list")

      msg = [
        "ID                                    NAME",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/cli",
        "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  tb-render/api"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#info" do
    before { allow(Sem::API::Projects).to receive(:info).and_return(project) }

    it "calls the API" do
      expect(Sem::API::Projects).to receive(:info).with("renderedtext/cli")

      sem_run("projects:info renderedtext/cli")
    end

    it "shows detailed information about an organization" do
      stdout, stderr = sem_run("projects:info renderedtext/cli")

      msg = [
        "ID       3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name     renderedtext/cli",
        "Created  2017-08-01 13:14:40 +0200",
        "Updated  2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end
end
