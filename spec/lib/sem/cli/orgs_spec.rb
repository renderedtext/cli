require "spec_helper"

describe Sem::CLI::Orgs do

  let(:org) { ApiResponse.organization }

  describe "#list" do
    context "you have one or more orgs" do
      it "lists all organizations" do
        stub_api(:get, "/orgs").to_return(200, [org])

        stdout, _stderr = sem_run!("orgs:list")

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
      it "displays the info" do
        stub_api(:get, "/orgs/rt").to_return(200, org)

        stdout, _stderr = sem_run!("orgs:info rt")

        expect(stdout).to include(org[:username])
      end
    end

    context "organization doesn't exists" do
      it "displays org not found" do
        stub_api(:get, "/orgs/rt").to_return(404, org)

        _stdout, stderr, status = sem_run("orgs:info rt")

        expect(stderr).to include("Organization rt not found.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#members" do
    let(:user) { ApiResponse.user }

    it "list members of an organization" do
      stub_api(:get, "/orgs/rt").to_return(200, org)
      stub_api(:get, "/orgs/users").to_return(200, [user])

      stdout, _stderr = sem_run!("orgs:members rt")

      expect(stdout).to include("john-snow")
    end

    context "organization doesn't exists" do
      it "displays org not found" do
        stub_api(:get, "/orgs/rt").to_return(404, org)

        _stdout, stderr, status = sem_run("orgs:members rt")

        expect(stderr).to include("Organization rt not found.")
        expect(status).to eq(:fail)
      end
    end
  end

end
