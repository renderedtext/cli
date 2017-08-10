require "spec_helper"

describe Sem::API::Configs do
  let(:sem_api_configs) { subject }

  let(:configs_api) { instance_double(SemaphoreClient::Api::SharedConfig) }
  let(:client) { instance_double(SemaphoreClient, :shared_configs => configs_api) }

  let(:org_name) { "org" }

  let(:config_id) { 0 }
  let(:config_name) { "config" }
  let(:config_hash) { { :id => config_id } }

  let(:config) { instance_double(SemaphoreClient::Model::SharedConfig, :id => config_id, :name => config_name) }

  before do
    allow(sem_api_configs).to receive(:client).and_return(client)
    allow(sem_api_configs).to receive(:to_hash).and_return(config_hash)
    allow(described_class).to receive(:new).and_return(sem_api_configs)
  end

  describe ".list" do
    before { allow(sem_api_configs).to receive(:list).and_return([config_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list
    end

    it "passes the call to the instance" do
      expect(sem_api_configs).to receive(:list)

      described_class.list
    end

    it "returns the result" do
      return_value = described_class.list

      expect(return_value).to eql([config_hash])
    end
  end

  describe ".list_for_org" do
    before { allow(sem_api_configs).to receive(:list_for_org).and_return([config_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list_for_org(org_name)
    end

    it "passes the call to the instance" do
      expect(sem_api_configs).to receive(:list_for_org).with(org_name)

      described_class.list_for_org(org_name)
    end

    it "returns the result" do
      return_value = described_class.list_for_org(org_name)

      expect(return_value).to eql([config_hash])
    end
  end

  describe "#list" do
    let(:org_username) { "org" }
    let(:org) { { :username => org_username } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(sem_api_configs).to receive(:list_for_org).and_return([config_hash])
    end

    it "calls list on the sem_api_orgs" do
      expect(Sem::API::Orgs).to receive(:list)

      sem_api_configs.list
    end

    it "calls list_for_org on the subject" do
      expect(sem_api_configs).to receive(:list_for_org).with(org_username)

      sem_api_configs.list
    end

    it "returns the config hashes" do
      return_value = sem_api_configs.list

      expect(return_value).to eql([config_hash])
    end
  end

  describe "#list_for_project" do
    before { allow(configs_api).to receive(:list_for_org).and_return([config]) }

    it "calls list_for_org on the configs_api" do
      expect(configs_api).to receive(:list_for_org).with(org_name)

      sem_api_configs.list_for_org(org_name)
    end

    it "converts the configs to config hashes" do
      expect(sem_api_configs).to receive(:to_hash).with(config)

      sem_api_configs.list_for_org(org_name)
    end

    it "returns the config hashes" do
      return_value = sem_api_configs.list_for_org(org_name)

      expect(return_value).to eql([config_hash])
    end
  end

  describe "#to_hash" do
    before { allow(sem_api_configs).to receive(:to_hash).and_call_original }

    it "returns the hash" do
      return_value = sem_api_configs.send(:to_hash, config)

      expect(return_value).to eql(:id => 0, :name => "config")
    end
  end
end
