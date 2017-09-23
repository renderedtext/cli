require "spec_helper"

describe Sem::CLI::Orgs do

  let(:org) { StubFactory.organization }

  describe "#list" do
    context "you have one or more orgs" do
      it "lists all organizations" do
        stub_api(:get, "/orgs").to_return(200, [org])

        stdout, stderr, status = sem_run("orgs:list")

        expect(stdout).to include(org[:username])
      end
    end

    context "you have no orgs" do
      it "offers you to create your first org" do
        stub_api(:get, "/orgs").to_return(200, [])

        expect(Sem::Views::Orgs).to receive(:create_first_org)

        sem_run("orgs:list")
      end
    end
  end

  describe "#info" do
    context "organization exists" do
      it "get info about an organization" do
        stub_api(:get, "/orgs/rt").to_return(200, org)

        stdout, stderr, status = sem_run("orgs:info rt")

        expect(stdout).to include(org[:username])
      end
    end

    context "organization doesn't exists" do
      it "get info about an organization" do
        stub_api(:get, "/orgs/rt").to_return(404, org)

        stdout, stderr, status = sem_run("orgs:info rt")

        expect(stdout).to include("Organization rt not found.")
      end
    end
  end

  describe "#members" do
    let(:user) { StubFactory.user }

    it "list members of an organization" do
      stub_api(:get, "/orgs/rt").to_return(200, org)
      stub_api(:get, "/orgs/users").to_return(200, [user])

      stdout, stderr, status = sem_run("orgs:members rt")

      expect(stdout).to include("john-snow")
    end
  end

end
