require "spec_helper"

require_relative "traits/shared_examples_for_associated_with_org"
require_relative "traits/shared_examples_for_associated_with_team"

describe Sem::API::SharedConfigs do
  let(:class_api) { instance_double(SemaphoreClient::Api::SharedConfig) }
  let(:client) { instance_double(SemaphoreClient, :shared_configs => class_api) }

  let(:org_name) { "org" }
  let(:team_name) { "team" }

  let(:instance_id) { 0 }
  let(:instance_name) { "config" }
  let(:instance_hash) do
    {
      :id => instance_id,
      :name => instance_name,
      :org => org_name,
      :config_files => 1,
      :env_vars => 2,
      :created_at => 123,
      :updated_at => 456
    }
  end

  let(:instance) do
    instance_double(SemaphoreClient::Model::SharedConfig,
                    :id => instance_id,
                    :name => instance_name,
                    :created_at => 123,
                    :updated_at => 456)
  end

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

      described_class.info(org_name, instance_name)
    end

    it "returns the selected instance" do
      return_value = described_class.info(org_name, instance_name)

      expect(return_value).to eql(instance_hash_0)
    end

    context "resource not found" do
      before { allow(described_class).to receive(:list_for_org).and_return([]) }

      it "raises an exception" do
        expected_message = "Shared Configuration #{org_name}/#{instance_name} not found."

        expect { described_class.info(org_name, instance_name) }.to raise_exception(Sem::Errors::ResourceNotFound,
                                                                                    expected_message)
      end
    end
  end

  describe ".create" do
    let(:args) { { :id => 0 } }

    before { allow(class_api).to receive(:create_for_org).and_return(instance) }

    it "calls create_for_org on the class_api" do
      expect(class_api).to receive(:create_for_org).with(org_name, args)

      described_class.create(org_name, args)
    end

    it "converts the instance to instance hash" do
      expect(described_class).to receive(:to_hash).with(instance, org_name)

      described_class.create(org_name, args)
    end

    it "returns the instance hash" do
      return_value = described_class.create(org_name, args)

      expect(return_value).to eql(instance_hash)
    end
  end

  describe ".update" do
    let(:args) { { "name" => instance_name } }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(class_api).to receive(:update)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(org_name, instance_name)

      described_class.update(org_name, instance_name, args)
    end

    it "calls delete on the class_api" do
      expect(class_api).to receive(:update).with(instance_id, args)

      described_class.update(org_name, instance_name, args)
    end

    it "returns the instance hash" do
      return_value = described_class.update(org_name, instance_name, args)

      expect(return_value).to eql(instance_hash)
    end
  end

  describe ".delete" do
    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(class_api).to receive(:delete)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(org_name, instance_name)

      described_class.delete(org_name, instance_name)
    end

    it "calls delete on the class_api" do
      expect(class_api).to receive(:delete).with(instance_id)

      described_class.delete(org_name, instance_name)
    end
  end

  describe ".list_env_vars" do
    let(:env_var_hash) { { :id => 0 } }

    before { allow(Sem::API::EnvVars).to receive(:list_for_shared_config).and_return([env_var_hash]) }

    it "calls the env_vars api" do
      expect(Sem::API::EnvVars).to receive(:list_for_shared_config).with(org_name, instance_name)

      described_class.list_env_vars(org_name, instance_name)
    end

    it "returns the env_vars" do
      return_value = described_class.list_env_vars(org_name, instance_name)

      expect(return_value).to eql([env_var_hash])
    end
  end

  describe ".list_files" do
    let(:file_hash) { { :id => 0 } }

    before { allow(Sem::API::Files).to receive(:list_for_shared_config).and_return([file_hash]) }

    it "calls the files api" do
      expect(Sem::API::Files).to receive(:list_for_shared_config).with(org_name, instance_name)

      described_class.list_files(org_name, instance_name)
    end

    it "returns the files" do
      return_value = described_class.list_files(org_name, instance_name)

      expect(return_value).to eql([file_hash])
    end
  end

  describe ".api" do
    it "returns the API from the client" do
      return_value = described_class.api

      expect(return_value).to eql(class_api)
    end
  end

  describe ".to_hash" do
    let(:config_files_api) do
      instance_double(SemaphoreClient::Api::ConfigFile, :list_for_shared_config => ["config_file_0"])
    end

    let(:env_vars_api) do
      instance_double(SemaphoreClient::Api::EnvVar, :list_for_shared_config => ["env_var_0", "env_var_1"])
    end

    before do
      allow(described_class).to receive(:to_hash).and_call_original
      allow(client).to receive(:config_files).and_return(config_files_api)
      allow(client).to receive(:env_vars).and_return(env_vars_api)
    end

    it "returns the hash" do
      return_value = described_class.to_hash(instance, org_name)

      expect(return_value).to eql(instance_hash)
    end
  end
end
