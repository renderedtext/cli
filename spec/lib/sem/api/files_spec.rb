require "spec_helper"

require_relative "traits/associated_with_shared_config"

describe Sem::API::Files do
  let(:class_api) { instance_double(SemaphoreClient::Api::ConfigFile) }
  let(:client) { instance_double(SemaphoreClient, :config_files => class_api) }

  let(:instance_id) { 0 }
  let(:instance_name) { "file" }
  let(:instance_hash) { { :id => instance_id, :name => instance_name } }

  let(:instance) { instance_double(SemaphoreClient::Model::ConfigFile, :id => instance_id, :path => instance_name) }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(instance_hash)
  end

  it_behaves_like "associated_with_shared_config"

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

      expect(return_value).to eql(instance_hash)
    end
  end
end
