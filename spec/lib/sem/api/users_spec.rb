require "spec_helper"

describe Sem::API::Users do
  let(:sem_api_users) { subject }

  let(:users_api) { instance_double(SemaphoreClient::Api::User) }
  let(:client) { instance_double(SemaphoreClient, :users => users_api) }

  let(:user_name) { "user" }
  let(:team_path) { "team/#{user_name}" }

  let(:user_id) { 0 }
  let(:user_hash) { { :id => user_id } }

  let(:user) { instance_double(SemaphoreClient::Model::User, :uid => 0, :username => "name") }

  before do
    allow(sem_api_users).to receive(:client).and_return(client)
    allow(sem_api_users).to receive(:to_hash).and_return(user_hash)
    allow(described_class).to receive(:new).and_return(sem_api_users)
  end

  describe ".list" do
    before { allow(sem_api_users).to receive(:list).and_return([user_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list
    end

    it "passes the call to the instance" do
      expect(sem_api_users).to receive(:list)

      described_class.list
    end

    it "returns the result" do
      return_value = described_class.list

      expect(return_value).to eql([user_hash])
    end
  end

  describe ".list_for_team" do
    before { allow(sem_api_users).to receive(:list_for_team).and_return([user_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list_for_team(team_path)
    end

    it "passes the call to the instance" do
      expect(sem_api_users).to receive(:list_for_team).with(team_path)

      described_class.list_for_team(team_path)
    end

    it "returns the result" do
      return_value = described_class.list_for_team(team_path)

      expect(return_value).to eql([user_hash])
    end
  end

  describe ".info" do
    before { allow(sem_api_users).to receive(:info).and_return(user_hash) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.info(user_name)
    end

    it "passes the call to the instance" do
      expect(sem_api_users).to receive(:info).with(user_name)

      described_class.info(user_name)
    end

    it "returns the result" do
      return_value = described_class.info(user_name)

      expect(return_value).to eql(user_hash)
    end
  end

  describe ".add_to_team" do
    before { allow(sem_api_users).to receive(:add_to_team) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.add_to_team(team_path, user_name)
    end

    it "passes the call to the instance" do
      expect(sem_api_users).to receive(:add_to_team).with(team_path, user_name)

      described_class.add_to_team(team_path, user_name)
    end
  end

  describe ".remove_from_team" do
    before { allow(sem_api_users).to receive(:remove_from_team) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.remove_from_team(team_path, user_name)
    end

    it "passes the call to the instance" do
      expect(sem_api_users).to receive(:remove_from_team).with(team_path, user_name)

      described_class.remove_from_team(team_path, user_name)
    end
  end

  describe "#list" do
    let(:org_username) { "org" }
    let(:org) { { :username => org_username } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(users_api).to receive(:list_for_org).and_return([user])
    end

    it "calls list on the orgs_api" do
      expect(Sem::API::Orgs).to receive(:list)

      sem_api_users.list
    end

    it "calls list_for_org on the users_api" do
      expect(users_api).to receive(:list_for_org).with(org_username)

      sem_api_users.list
    end

    it "converts the users to user hashes" do
      expect(sem_api_users).to receive(:to_hash).with(user)

      sem_api_users.list
    end

    it "returns the user hashes" do
      return_value = sem_api_users.list

      expect(return_value).to eql([user_hash])
    end
  end

  describe "#list_for_team" do
    let(:team_path) { "org/team" }
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(users_api).to receive(:list_for_team).and_return([user])
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      sem_api_users.list_for_team(team_path)
    end

    it "calls list_for_team on the users_api" do
      expect(users_api).to receive(:list_for_team).with(team_id)

      sem_api_users.list_for_team(team_path)
    end

    it "converts the users to user hashes" do
      expect(sem_api_users).to receive(:to_hash).with(user)

      sem_api_users.list_for_team(team_path)
    end

    it "returns the user hashes" do
      return_value = sem_api_users.list_for_team(team_path)

      expect(return_value).to eql([user_hash])
    end
  end

  describe "#info" do
    let(:user_hash_0) { { :username => user_name } }
    let(:user_hash_1) { { :username => "user_1" } }

    before { allow(sem_api_users).to receive(:list).and_return([user_hash_0, user_hash_1]) }

    it "calls list on the subject" do
      expect(sem_api_users).to receive(:list)

      sem_api_users.info(user_name)
    end

    it "returns the selected user" do
      return_value = sem_api_users.info(user_name)

      expect(return_value).to eql(user_hash_0)
    end
  end

  describe "#add_to_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(sem_api_users).to receive(:info).and_return(user_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(users_api).to receive(:attach_to_team)
    end

    it "calls info on the subject" do
      expect(sem_api_users).to receive(:info).with(user_name)

      sem_api_users.add_to_team(team_path, user_name)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      sem_api_users.add_to_team(team_path, user_name)
    end

    it "calls attach_to_team on the users_api" do
      expect(users_api).to receive(:attach_to_team).with(user_id, team_id)

      sem_api_users.add_to_team(team_path, user_name)
    end
  end

  describe "#remove_from_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(sem_api_users).to receive(:info).and_return(user_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(users_api).to receive(:detach_from_team)
    end

    it "calls info on the subject" do
      expect(sem_api_users).to receive(:info).with(user_name)

      sem_api_users.remove_from_team(team_path, user_name)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      sem_api_users.remove_from_team(team_path, user_name)
    end

    it "calls detach_from_team on the users_api" do
      expect(users_api).to receive(:detach_from_team).with(user_id, team_id)

      sem_api_users.remove_from_team(team_path, user_name)
    end
  end

  describe "#to_hash" do
    before { allow(sem_api_users).to receive(:to_hash).and_call_original }

    it "returns the hash" do
      return_value = sem_api_users.send(:to_hash, user)

      expect(return_value).to eql(:id => 0, :username => "name")
    end
  end
end
