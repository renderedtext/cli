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

  describe ".list_admins" do
    let(:team_1) { { :id => 0, :permission => "admin" } }
    let(:team_2) { { :id => 1, :permission => "write" } }

    let(:user) { instance_double(SemaphoreClient::Model::User) }
    let(:user_hash) { { :id => 0 } }
    let(:users_api) { instance_double(SemaphoreClient::Api::User, :list_for_team => [user]) }

    before do
      allow(described_class).to receive(:list_teams).and_return([team_1, team_2])
      allow(client).to receive(:users).and_return(users_api)
      allow(Sem::API::Users).to receive(:to_hash).and_return(user_hash)
    end

    it "lists the teams" do
      expect(described_class).to receive(:list_teams).with(instance_name)

      described_class.list_admins(instance_name)
    end

    it "lists users for admin teams" do
      expect(users_api).to receive(:list_for_team).with(team_1[:id])

      described_class.list_admins(instance_name)
    end

    it "doesn't list users for non-admin teams" do
      expect(users_api).not_to receive(:list_for_team).with(team_2[:id])

      described_class.list_admins(instance_name)
    end

    it "converts users to hashes" do
      expect(Sem::API::Users).to receive(:to_hash).with(user)

      described_class.list_admins(instance_name)
    end

    it "returns the admins" do
      return_value = described_class.list_admins(instance_name)

      expect(return_value).to eql([user_hash])
    end
  end

  describe ".list_owners" do
    let(:team_1) { { :id => 0, :name => "Owners" } }
    let(:team_2) { { :id => 1, :name => "Others" } }

    let(:user) { instance_double(SemaphoreClient::Model::User) }
    let(:user_hash) { { :id => 0 } }
    let(:users_api) { instance_double(SemaphoreClient::Api::User, :list_for_team => [user]) }

    before do
      allow(described_class).to receive(:list_teams).and_return([team_1, team_2])
      allow(client).to receive(:users).and_return(users_api)
      allow(Sem::API::Users).to receive(:to_hash).and_return(user_hash)
    end

    it "lists the teams" do
      expect(described_class).to receive(:list_teams).with(instance_name)

      described_class.list_owners(instance_name)
    end

    it "lists users for the Owners team" do
      expect(users_api).to receive(:list_for_team).with(team_1[:id])

      described_class.list_owners(instance_name)
    end

    it "doesn't list users for non-owner teams" do
      expect(users_api).not_to receive(:list_for_team).with(team_2[:id])

      described_class.list_owners(instance_name)
    end

    it "converts users to hashes" do
      expect(Sem::API::Users).to receive(:to_hash).with(user)

      described_class.list_owners(instance_name)
    end

    it "returns the admins" do
      return_value = described_class.list_owners(instance_name)

      expect(return_value).to eql([user_hash])
    end
  end

  describe ".check_path" do
    context "path format is correct" do
      it "doesn't raise an exception" do
        expect { described_class.check_path("org") }.not_to raise_exception
      end
    end

    context "path format isn't correct" do
      it "raises an exception" do
        expect { described_class.check_path("org/org") }.to raise_exception(Sem::Errors::InvalidPath)
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
      return_value = described_class.to_hash(instance)

      expect(return_value).to eql(instance_hash)
    end
  end
end
