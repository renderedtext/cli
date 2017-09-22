require "spec_helper"

describe Sem::CLI::Orgs do

  let(:org) { StubFactory.organization }
  let(:user) { StubFactory.user }

  describe "#list" do
    context "you have one or more orgs" do
      it "lists all organizations" do
        orgs = [org]

        expect(Sem::API::Org).to receive(:all).and_return(orgs)
        expect(Sem::Views::Orgs).to receive(:list).with(orgs)

        sem_run("orgs:list")
      end
    end

    context "you have no orgs" do
      it "offers you to create your first org" do
        expect(Sem::API::Org).to receive(:all).and_return([])
        expect(Sem::Views::Orgs).to receive(:create_first_org)

        sem_run("orgs:list")
      end
    end
  end

  describe "#info" do
    it "get info about an organization" do
      expect(Sem::API::Org).to receive(:find!).with("rt").and_return(org)
      expect(Sem::Views::Orgs).to receive(:info).with(org)

      sem_run("orgs:info rt")
    end
  end

  describe "#members" do
    before do
      allow(org).to receive(:users).and_return([user])
    end

    it "list members of an organization" do
      expect(Sem::API::Org).to receive(:find!).with("rt").and_return(org)
      expect(Sem::Views::Users).to receive(:list).with([user])

      sem_run("orgs:members rt")
    end
  end

end
