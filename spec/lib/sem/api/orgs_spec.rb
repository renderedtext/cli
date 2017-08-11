require "spec_helper"

describe Sem::API::Orgs do
  let(:class_api) { instance_double(SemaphoreClient::Api::Org) }
  let(:client) { instance_double(SemaphoreClient, :orgs => class_api) }

  let(:instance_id) { 0 }
  let(:instance_hash) { { :id => instance_id } }

  let(:instance) { instance_double(SemaphoreClient::Model::Org, :id => instance_id, :username => "name") }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(instance_hash)
  end

  describe ".list" do
    before do
      allow(class_api).to receive(:list).and_return([instance])
    end

    it "calls list on the class_api" do
      expect(class_api).to receive(:list)

      described_class.list
    end

    it "converts the instances to instance hashes" do
      expect(described_class).to receive(:to_hash).with(instance)

      described_class.list
    end

    it "returns the team hashes" do
      return_value = described_class.list

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".api" do
    it "returns the API from the client" do
      return_value = described_class.api

      expect(return_value).to eql(class_api)
    end
  end

  describe ".to_hash" do
    before { allow(described_class).to receive(:to_hash).and_call_original }

    it "returns the hash" do
      return_value = described_class.to_hash(instance)

      expect(return_value).to eql(:id => 0, :username => "name")
    end
  end
end
