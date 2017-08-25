require "spec_helper"

describe Sem::API::Orgs do
  let(:class_api) { instance_double(SemaphoreClient::Api::Org) }
  let(:client) { instance_double(SemaphoreClient, :orgs => class_api) }

  let(:instance_id) { 0 }
  let(:instance_name) { "org" }
  let(:instance_hash) do
    {
      :id => instance_id,
      :username => instance_name,
      :created_at => 123,
      :updated_at => 456
    }
  end

  let(:instance) do
    instance_double(SemaphoreClient::Model::Org,
                    :id => instance_id,
                    :username => instance_name,
                    :created_at => 123,
                    :updated_at => 456)
  end

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(instance_hash)
  end

  describe ".list" do
    before { allow(class_api).to receive(:list).and_return([instance]) }

    it "calls list on the class_api" do
      expect(class_api).to receive(:list)

      described_class.list
    end

    it "converts the instances to instance hashes" do
      expect(described_class).to receive(:to_hash).with(instance)

      described_class.list
    end

    it "returns the instance hashes" do
      return_value = described_class.list

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".info" do
    before { allow(class_api).to receive(:get).and_return(instance) }

    it "calls get on the class_api" do
      expect(class_api).to receive(:get).with(instance_name)

      described_class.info(instance_name)
    end

    it "converts the instance to instance hash" do
      expect(described_class).to receive(:to_hash).with(instance)

      described_class.info(instance_name)
    end

    it "returns the instance hash" do
      return_value = described_class.info(instance_name)

      expect(return_value).to eql(instance_hash)
    end

    context "resource not found" do
      before { allow(class_api).to receive(:get).and_return(nil) }

      it "raises an exception" do
        expected_message = "[ERROR] Organization lookup failed\n\nOrganization #{instance_name} not found."

        expect { described_class.info(instance_name) }.to raise_exception(Sem::Errors::ResourceNotFound,
                                                                          expected_message)
      end
    end
  end

  describe ".list_teams" do
    let(:team_hash) { { :id => 0 } }

    before { allow(Sem::API::Teams).to receive(:list_for_org).and_return([team_hash]) }

    it "calls the teams api" do
      expect(Sem::API::Teams).to receive(:list_for_org).with(instance_name)

      described_class.list_teams(instance_name)
    end

    it "returns the teams" do
      return_value = described_class.list_teams(instance_name)

      expect(return_value).to eql([team_hash])
    end
  end

  describe ".list_users" do
    let(:user_hash) { { :id => 0 } }

    before { allow(Sem::API::Users).to receive(:list_for_org).and_return([user_hash]) }

    it "calls the users api" do
      expect(Sem::API::Users).to receive(:list_for_org).with(instance_name)

      described_class.list_users(instance_name)
    end

    it "returns the users" do
      return_value = described_class.list_users(instance_name)

      expect(return_value).to eql([user_hash])
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

      expect(return_value).to eql(instance_hash)
    end
  end
end
