require "spec_helper"

describe Sem::CLI::Orgs do

  let(:org) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :username => "renderedtext",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    context "when the user belongs to at least one organization" do
      let(:another_org) do
        {
          :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0",
          :username => "tb-render"
        }
      end

      before { allow(Sem::API::Orgs).to receive(:list).and_return([org, another_org]) }

      it "calls the API" do
        expect(Sem::API::Orgs).to receive(:list)

        sem_run("orgs:list")
      end

      it "lists organizations" do
        stdout, stderr, status = sem_run("orgs:list")

        msg = [
          "ID                                    NAME",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext",
          "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  tb-render"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

    context "when the user belongs to no organization" do
      before do
        allow(Sem::API::Orgs).to receive(:list).and_return([])
      end

      it "offers the user to create hos first organization" do
        stdout, stderr, status = sem_run("orgs:list")

        msg = [
          "You don't belong to any organization.",
          "",
          "Create your first organization: https://semaphoreci.com/organizations/new.",
          "",
          ""
        ]

        expect(stdout).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end
  end

  describe "#info" do
    before { allow(Sem::API::Orgs).to receive(:info).and_return(org) }

    it "calls the API" do
      expect(Sem::API::Orgs).to receive(:info)

      sem_run("orgs:info renderedtext")
    end

    it "shows detailed information about an organization" do
      stdout, stderr, status = sem_run("orgs:info renderedtext")

      msg = [
        "ID       3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name     renderedtext",
        "Created  2017-08-01 13:14:40 +0200",
        "Updated  2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
      expect(status).to eq(:ok)
    end
  end

  describe "#members" do
    let(:user_1) { { :id => "ijovan", :permission => "write" } }
    let(:user_2) { { :id => "shiroyasha", :permission => "admin" } }

    before do
      allow(Sem::API::Users).to receive(:list_for_org).and_return([user_1, user_2])
    end

    it "calls the API" do
      expect(Sem::API::Users).to receive(:list_for_org).with("renderedtext")

      sem_run("orgs:members renderedtext")
    end

    it "list members in an organization" do
      stdout, stderr, status = sem_run("orgs:members renderedtext")

      msg = [
        "NAME",
        "ijovan",
        "shiroyasha"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
      expect(status).to eq(:ok)
    end
  end

end
