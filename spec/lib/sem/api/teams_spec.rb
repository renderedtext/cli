require "spec_helper"

require_relative "traits/shared_examples_for_associated_with_org"

describe Sem::API::Teams do
  let(:class_api) { instance_double(SemaphoreClient::Api::Team) }
  let(:client) { instance_double(SemaphoreClient, :teams => class_api) }

  let(:org_name) { "org_0" }
  let(:instance_name) { "instance" }
  let(:path) { "#{org_name}/#{instance_name}" }

  let(:instance_id) { 0 }
  let(:instance_hash) { { :id => instance_id } }

  let(:instance) do
    instance_double(SemaphoreClient::Model::Team,
                    :id => instance_id,
                    :name => "team_0",
                    :permission => "read",
                    :created_at => 123,
                    :updated_at => 456)
  end

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(instance_hash)
  end

  it_behaves_like "associated_with_org"

  describe ".list" do
    let(:org) { { :username => org_name } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(described_class).to receive(:list_for_org).and_return([instance_hash])
    end

    it "calls list on the sem_api_orgs" do
      expect(Sem::API::Orgs).to receive(:list)

      described_class.list
    end

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_name)

      described_class.list
    end

    it "returns the instance hashes" do
      return_value = described_class.list

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".info" do
    let(:instance_hash_0) { { :name => instance_name } }
    let(:instance_hash_1) { { :name => "team_1" } }

    before { allow(described_class).to receive(:list_for_org).and_return([instance_hash_0, instance_hash_1]) }

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_name)

      described_class.info(path)
    end

    it "returns the selected instance" do
      return_value = described_class.info(path)

      expect(return_value).to eql(instance_hash_0)
    end
  end

  describe ".create" do
    let(:args) { { :name => instance_name } }

    before { allow(class_api).to receive(:create_for_org).and_return(instance) }

    it "calls create_for_org on the class_api" do
      expect(class_api).to receive(:create_for_org).with(org_name, args)

      described_class.create(org_name, args)
    end

    it "converts the instance to instacen hash" do
      expect(described_class).to receive(:to_hash).with(instance)

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
      expect(described_class).to receive(:info).with(path)

      described_class.update(path, args)
    end

    it "calls delete on the class_api" do
      expect(class_api).to receive(:update).with(instance_id, args)

      described_class.update(path, args)
    end

    it "returns the instance hash" do
      return_value = described_class.update(path, args)

      expect(return_value).to eql(instance_hash)
    end
  end

  describe ".delete" do
    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(class_api).to receive(:delete)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(path)

      described_class.delete(path)
    end

    it "calls delete on the class_api" do
      expect(class_api).to receive(:delete).with(instance_id)

      described_class.delete(path)
    end
  end

  describe ".api" do
    it "returns the API from the client" do
      return_value = described_class.api

      expect(return_value).to eql(class_api)
    end
  end

  describe ".to_hash" do
    let(:users_api) { instance_double(SemaphoreClient::Api::User) }

    before do
      allow(client).to receive(:users).and_return(users_api)
      allow(users_api).to receive(:list_for_team).and_return(["user_0", "user_1"])
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:to_hash).and_call_original
    end

    it "lists the users" do
      expect(users_api).to receive(:list_for_team).with(instance_id)

      described_class.to_hash(instance)
    end

    it "returns the hash" do
      return_value = described_class.to_hash(instance)

      expect(return_value).to eql(
        :id => instance_id,
        :name => instance.name,
        :permission => instance.permission,
        :members => "2",
        :created_at => instance.created_at,
        :updated_at => instance.updated_at
      )
    end
  end
end
