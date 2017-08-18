require "spec_helper"

describe Sem::CLI::Orgs do

  let(:org) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "renderedtext",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    let(:another_org) do
      {
        :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0",
        :name => "tb-render"
      }
    end

    before { allow(Sem::API::Orgs).to receive(:list).and_return([org, another_org]) }

    it "calls the API" do
      expect(Sem::API::Orgs).to receive(:list)

      sem_run("orgs:list")
    end

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
    before { allow(Sem::API::Orgs).to receive(:info).and_return(org) }

    it "calls the API" do
      expect(Sem::API::Orgs).to receive(:info)

      sem_run("orgs:info renderedtext")
    end

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

  describe "#members" do
    let(:user_1) { { :id => "ijovan", :permission => "write" } }
    let(:user_2) { { :id => "shiroyasha", :permission => "admin" } }

    before do
      allow(Sem::API::UsersWithPermissions).to receive(:list_for_org).and_return([user_1, user_2])
      allow(Sem::API::UsersWithPermissions).to receive(:list_admins_for_org).and_return([user_2])
      allow(Sem::API::UsersWithPermissions).to receive(:list_owners_for_org).and_return([user_2])
    end

    it "calls the API" do
      expect(Sem::API::UsersWithPermissions).to receive(:list_for_org).with("renderedtext")

      sem_run("orgs:members renderedtext")
    end

    context "admins option is true" do
      it "calls the API" do
        expect(Sem::API::UsersWithPermissions).to receive(:list_admins_for_org).with("renderedtext")

        sem_run("orgs:members renderedtext --admins")
      end
    end

    context "owners option is true" do
      it "calls the API" do
        expect(Sem::API::UsersWithPermissions).to receive(:list_owners_for_org).with("renderedtext")

        sem_run("orgs:members renderedtext --owners true")
      end
    end

    it "list members in an organization" do
      stdout, stderr = sem_run("orgs:members renderedtext")

      msg = [
        "NAME        PERMISSION",
        "ijovan      write",
        "shiroyasha  admin"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

end
