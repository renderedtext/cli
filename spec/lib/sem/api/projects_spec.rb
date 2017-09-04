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

  describe ".info" do
    before { allow(class_api).to receive(:list_for_org).and_return([instance_hash]) }

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

  describe ".create" do
    let(:args) { { :name => "cli", :repo_provider => "github", :repo_owner => "renderedtext", :repo_name => "cli" } }

    before { allow(class_api).to receive(:create_for_org).and_return(instance) }

    it "calls create_for_org on the class_api" do
      expect(class_api).to receive(:create_for_org).with(org_name, args)

      described_class.create(org_name, args)
    end

    it "converts the instance to instacen hash" do
      expect(described_class).to receive(:to_hash).with(instance, org_name)

      described_class.create(org_name, args)
    end

    it "returns the instance hash" do
      return_value = described_class.create(org_name, args)

      expect(return_value).to eql(instance_hash)
    end

    context "resource creation failed" do
      before { allow(class_api).to receive(:create_for_org).and_return(nil) }

      it "raises an exception" do
        expect { described_class.create(org_name, args) }.to raise_exception(Sem::Errors::ResourceNotCreated)
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
