require "spec_helper"

describe Sem::API::Orgs do
  let(:sem_api_orgs) { subject }

  let(:orgs_api) { instance_double(SemaphoreClient::Api::Org) }
  let(:client) { instance_double(SemaphoreClient, :orgs => orgs_api) }

  let(:org_id) { 0 }
  let(:org_hash) { { :id => org_id } }

  let(:org) { instance_double(SemaphoreClient::Model::Org, :id => org_id, :username => "name") }

  before do
    allow(sem_api_orgs).to receive(:client).and_return(client)
    allow(sem_api_orgs).to receive(:to_hash).and_return(org_hash)
    allow(described_class).to receive(:new).and_return(sem_api_orgs)
  end

  describe ".list" do
    before { allow(sem_api_orgs).to receive(:list).and_return([org_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list
    end

    it "passes the call to the instance" do
      expect(sem_api_orgs).to receive(:list)

      described_class.list
    end

    it "returns the result" do
      return_value = described_class.list

      expect(return_value).to eql([org_hash])
    end
  end

  describe "#list" do
    before do
      allow(orgs_api).to receive(:list).and_return([org])
    end

    it "calls list on the orgs_api" do
      expect(orgs_api).to receive(:list)

      sem_api_orgs.list
    end

    it "converts the orgs to org hashes" do
      expect(sem_api_orgs).to receive(:to_hash).with(org)

      sem_api_orgs.list
    end

    it "returns the team hashes" do
      return_value = sem_api_orgs.list

      expect(return_value).to eql([org_hash])
    end
  end

  describe "#to_hash" do
    before { allow(sem_api_orgs).to receive(:to_hash).and_call_original }

    it "returns the hash" do
      return_value = sem_api_orgs.send(:to_hash, org)

      expect(return_value).to eql(:id => 0, :username => "name")
    end
  end
end
