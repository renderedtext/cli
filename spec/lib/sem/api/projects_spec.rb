require "spec_helper"

require_relative "traits/shared_examples_for_associated_with_org"
require_relative "traits/shared_examples_for_associated_with_team"

describe Sem::API::Projects do
  let(:class_api) { instance_double(SemaphoreClient::Api::Project) }
  let(:client) { instance_double(SemaphoreClient, :projects => class_api) }

  let(:org_name) { "org" }
  let(:team_name) { "team" }

  let(:instance_id) { 0 }
  let(:instance_name) { "project" }
  let(:instance_hash) do
    {
      :id => instance_id,
      :name => instance_name,
      :org => org_name,
      :created_at => 123,
      :updated_at => 456
    }
  end

  let(:instance) do
    instance_double(SemaphoreClient::Model::Project,
                    :id => instance_id,
                    :name => instance_name,
                    :created_at => 123,
                    :updated_at => 456)
  end

  let(:project) { instance }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(instance_hash)
  end

  it_behaves_like "associated_with_org"
  it_behaves_like "associated_with_team"

  describe ".name_to_id" do
    before { allow(described_class).to receive(:info).with(org_name, instance_name).and_return(instance_hash) }

    it "returns the id" do
      return_value = described_class.name_to_id(org_name, instance_name)

      expect(return_value).to eql(instance_id)
    end
  end

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

  describe ".list_files" do
    let(:env_var) do
      instance_double(SemaphoreClient::Model::EnvVar,
                      :id => "2121",
                      :name => "/etc/init",
                      :content => "aaa",
                      :encrypted => true)
    end

    let(:env_vars_api) { instance_double(SemaphoreClient::Api::EnvVar) }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(described_class).to receive_message_chain(:client, :env_vars).and_return(env_vars_api)
      allow(env_vars_api).to receive(:list_for_project).and_return([env_var])
    end

    it "returns the env_vars" do
      return_value = described_class.list_env_vars(org_name, instance_name)

      expect(return_value).to eql([{ :id => "2121", :name => "/etc/init", :encrypted? => true, :content => "aaa" }])
    end
  end

  describe ".list_files" do
    let(:file) do
      instance_double(SemaphoreClient::Model::ConfigFile,
                      :id => "2121",
                      :path => "/etc/init",
                      :encrypted => true)
    end

    let(:config_files_api) { instance_double(SemaphoreClient::Api::ConfigFile) }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(described_class).to receive_message_chain(:client, :config_files).and_return(config_files_api)
      allow(config_files_api).to receive(:list_for_project).and_return([file])
    end

    it "returns the files" do
      return_value = described_class.list_files(org_name, instance_name)

      expect(return_value).to eql([{ :id => "2121", :name => "/etc/init", :encrypted? => true }])
    end
  end

  describe ".info" do
    before do
      allow(class_api).to receive(:list_for_org).and_return([instance_hash])
    end

    it "calls list_for_org on the class api" do
      expect(class_api).to receive(:list_for_org).with(org_name, :name => instance_name)

      described_class.info(org_name, instance_name)
    end

    it "returns the selected instance" do
      return_value = described_class.info(org_name, instance_name)

      expect(return_value).to eql(instance_hash)
    end

    context "resource not found" do
      before { allow(class_api).to receive(:list_for_org).and_return([]) }

      it "raises an exception" do
        expected_message = "[ERROR] Project lookup failed\n\nProject #{org_name}/#{instance_name} not found."

        expect { described_class.info(org_name, instance_name) }.to raise_exception(Sem::Errors::ResourceNotFound,
                                                                                    expected_message)
      end
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
      return_value = described_class.to_hash(instance, org_name)

      expect(return_value).to eql(instance_hash)
    end
  end
end
