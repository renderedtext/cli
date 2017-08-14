require "spec_helper"

require_relative "traits/associated_with_org_spec"
require_relative "traits/associated_with_team_spec"

describe Sem::API::SharedConfigs do
  let(:class_api) { instance_double(SemaphoreClient::Api::SharedConfig) }
  let(:client) { instance_double(SemaphoreClient, :shared_configs => class_api) }

  let(:org_name) { "org" }
  let(:instance_path) { "#{org_name}/config" }
  let(:team_path) { "#{org_name}/team" }

  let(:instance_id) { 0 }
  let(:instance_name) { "config" }
  let(:instance_hash) { { :id => instance_id } }

  let(:instance) { instance_double(SemaphoreClient::Model::SharedConfig, :id => instance_id, :name => instance_name) }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(instance_hash)
  end

  it_behaves_like "associated_with_org"
  it_behaves_like "associated_with_team"

  describe ".list" do
    let(:org_username) { "org" }
    let(:org) { { :username => org_username } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(described_class).to receive(:list_for_org).and_return([instance_hash])
    end

    it "calls list on the sem_api_orgs" do
      expect(Sem::API::Orgs).to receive(:list)

      described_class.list
    end

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_username)

      described_class.list
    end

    it "returns the instance hashes" do
      return_value = described_class.list

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".info" do
    let(:instance_hash_0) { { :name => instance_name } }
    let(:instance_hash_1) { { :name => "config_1" } }

    before { allow(described_class).to receive(:list_for_org).and_return([instance_hash_0, instance_hash_1]) }

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_name)

      described_class.info(instance_path)
    end

    it "returns the selected instance" do
      return_value = described_class.info(instance_path)

      expect(return_value).to eql(instance_hash_0)
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

      expect(return_value).to eql(:id => 0, :name => "config")
    end
  end
end
