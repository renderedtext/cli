require "spec_helper"

require_relative "traits/shared_examples_for_associated_with_org"

describe Sem::API::Teams do
  let(:class_api) { instance_double(SemaphoreClient::Api::Team) }
  let(:client) { instance_double(SemaphoreClient, :teams => class_api) }

  let(:org_name) { "org" }
  let(:instance_name) { "instance" }

  let(:instance_id) { 0 }
  let(:instance_hash) do
    {
      :id => instance_id,
      :name => instance.name,
      :org => org_name,
      :permission => instance.permission,
      :members => "2",
      :created_at => instance.created_at,
      :updated_at => instance.updated_at
    }
  end

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

      described_class.info(org_name, instance_name)
    end

    it "returns the selected instance" do
      return_value = described_class.info(org_name, instance_name)

      expect(return_value).to eql(instance_hash_0)
    end

    context "resource not found" do
      before { allow(described_class).to receive(:list_for_org).and_return([]) }

      it "raises an exception" do
        expected_message = "[ERROR] Team lookup failed\n\nTeam #{org_name}/#{instance_name} not found."

        expect { described_class.info(org_name, instance_name) }.to raise_exception(Sem::Errors::ResourceNotFound,
                                                                                    expected_message)
      end
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
        expected_message = "[ERROR] Team creation failed\n\nTeam #{org_name}/#{instance_name} not created."

        expect { described_class.create(org_name, args) }.to raise_exception(Sem::Errors::ResourceNotCreated,
                                                                             expected_message)
      end
    end
  end

  describe ".update" do
    let(:args) { { :name => instance_name } }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(class_api).to receive(:update).and_return(instance)
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

    context "resource update failed" do
      before { allow(class_api).to receive(:update).and_return(nil) }

      it "raises an exception" do
        expected_message = "[ERROR] Team update failed\n\nTeam #{org_name}/#{instance_name} not updated."

        expect { described_class.update(org_name, instance_name, args) }.to raise_exception(
          Sem::Errors::ResourceNotUpdated,
          expected_message
        )
      end
    end
  end

  describe ".delete" do
    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(class_api).to receive(:delete!)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(org_name, instance_name)

      described_class.delete(org_name, instance_name)
    end

    it "calls delete on the class_api" do
      expect(class_api).to receive(:delete!).with(instance_id)

      described_class.delete(org_name, instance_name)
    end

    context "deletion failed" do
      before { allow(class_api).to receive(:delete!).and_raise(SemaphoreClient::Exceptions::RequestFailed) }

      it "raises an exception" do
        expected_message = "[ERROR] Team deletion failed\n\nTeam #{org_name}/#{instance_name} not deleted."

        expect { described_class.delete(org_name, instance_name) }.to raise_exception(Sem::Errors::ResourceNotDeleted,
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
    let(:users_api) { instance_double(SemaphoreClient::Api::User) }

    before do
      allow(client).to receive(:users).and_return(users_api)
      allow(users_api).to receive(:list_for_team).and_return(["user_0", "user_1"])
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:to_hash).and_call_original
    end

    it "lists the users" do
      expect(users_api).to receive(:list_for_team).with(instance_id)

      described_class.to_hash(instance, org_name)
    end

    it "returns the hash" do
      return_value = described_class.to_hash(instance, org_name)

      expect(return_value).to eql(instance_hash)
    end
  end
end
