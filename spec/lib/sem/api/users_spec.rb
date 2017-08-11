require "spec_helper"

describe Sem::API::Users do
  let(:users_api) { instance_double(SemaphoreClient::Api::User) }
  let(:client) { instance_double(SemaphoreClient, :users => users_api) }

  let(:user_name) { "user" }
  let(:team_path) { "org/team" }

  let(:user_id) { 0 }
  let(:user_hash) { { :id => user_id } }

  let(:user) { instance_double(SemaphoreClient::Model::User, :uid => 0, :username => "name") }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(user_hash)
  end

  describe ".list" do
    let(:org_username) { "org" }
    let(:org) { { :username => org_username } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(described_class).to receive(:list_for_org).and_return([user_hash])
    end

    it "calls list on the sem_api_orgs" do
      expect(Sem::API::Orgs).to receive(:list)

      described_class.list
    end

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_username)

      described_class.list
    end

    it "returns the user hashes" do
      return_value = described_class.list

      expect(return_value).to eql([user_hash])
    end
  end

  describe ".list_for_org" do
    let(:org_username) { "org" }

    before { allow(users_api).to receive(:list_for_org).and_return([user]) }

    it "calls list_for_org on the users_api" do
      expect(users_api).to receive(:list_for_org).with(org_username)

      described_class.list_for_org(org_username)
    end

    it "converts the users to user hashes" do
      expect(described_class).to receive(:to_hash).with(user)

      described_class.list_for_org(org_username)
    end

    it "returns the user hashes" do
      return_value = described_class.list_for_org(org_username)

      expect(return_value).to eql([user_hash])
    end
  end

  describe ".list_for_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(users_api).to receive(:list_for_team).and_return([user])
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.list_for_team(team_path)
    end

    it "calls list_for_team on the users_api" do
      expect(users_api).to receive(:list_for_team).with(team_id)

      described_class.list_for_team(team_path)
    end

    it "converts the users to user hashes" do
      expect(described_class).to receive(:to_hash).with(user)

      described_class.list_for_team(team_path)
    end

    it "returns the user hashes" do
      return_value = described_class.list_for_team(team_path)

      expect(return_value).to eql([user_hash])
    end
  end

  describe ".info" do
    let(:user_hash_0) { { :username => user_name } }
    let(:user_hash_1) { { :username => "user_1" } }

    before { allow(described_class).to receive(:list).and_return([user_hash_0, user_hash_1]) }

    it "calls list on the described class" do
      expect(described_class).to receive(:list)

      described_class.info(user_name)
    end

    it "returns the selected user" do
      return_value = described_class.info(user_name)

      expect(return_value).to eql(user_hash_0)
    end
  end

  describe ".add_to_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(described_class).to receive(:info).and_return(user_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(users_api).to receive(:attach_to_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(user_name)

      described_class.add_to_team(team_path, user_name)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.add_to_team(team_path, user_name)
    end

    it "calls attach_to_team on the users_api" do
      expect(users_api).to receive(:attach_to_team).with(user_id, team_id)

      described_class.add_to_team(team_path, user_name)
    end
  end

  describe ".remove_from_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(described_class).to receive(:info).and_return(user_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(users_api).to receive(:detach_from_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(user_name)

      described_class.remove_from_team(team_path, user_name)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.remove_from_team(team_path, user_name)
    end

    it "calls detach_from_team on the users_api" do
      expect(users_api).to receive(:detach_from_team).with(user_id, team_id)

      described_class.remove_from_team(team_path, user_name)
    end
  end

  describe ".api" do
    it "returns the API from the client" do
      return_value = described_class.api

      expect(return_value).to eql(users_api)
    end
  end

  describe ".to_hash" do
    before { allow(described_class).to receive(:to_hash).and_call_original }

    it "returns the hash" do
      return_value = described_class.to_hash(user)

      expect(return_value).to eql(:id => 0, :username => "name")
    end
  end
end
