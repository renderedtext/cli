require "spec_helper"

describe Sem::API::Teams do
  let(:teams_api) { instance_double(SemaphoreClient::Api::Team) }
  let(:client) { instance_double(SemaphoreClient, :teams => teams_api) }

  let(:org_name) { "org_0" }
  let(:team_name) { "team_0" }
  let(:path) { "#{org_name}/#{team_name}" }

  let(:team_id) { 0 }
  let(:team_hash) { { :id => team_id } }

  let(:team) do
    instance_double(SemaphoreClient::Model::Team,
                    :id => team_id,
                    :name => "team_0",
                    :permission => "read",
                    :created_at => 123,
                    :updated_at => 456)
  end

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(team_hash)
  end

  describe ".list" do
    let(:org) { { :username => org_name } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(described_class).to receive(:list_for_org).and_return([team_hash])
    end

    it "calls list on the sem_api_orgs" do
      expect(Sem::API::Orgs).to receive(:list)

      described_class.list
    end

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_name)

      described_class.list
    end

    it "returns the team hashes" do
      return_value = described_class.list

      expect(return_value).to eql([team_hash])
    end
  end

  describe ".list_for_org" do
    let(:org_name) { "org" }

    before { allow(teams_api).to receive(:list_for_org).and_return([team]) }

    it "calls list_for_org on the teams_api" do
      expect(teams_api).to receive(:list_for_org).with(org_name)

      described_class.list_for_org(org_name)
    end

    it "converts the teams to team hashes" do
      expect(described_class).to receive(:to_hash).with(team)

      described_class.list_for_org(org_name)
    end

    it "returns the team hashes" do
      return_value = described_class.list_for_org(org_name)

      expect(return_value).to eql([team_hash])
    end
  end

  describe ".info" do
    let(:team_hash_0) { { :name => team_name } }
    let(:team_hash_1) { { :name => "team_1" } }

    before { allow(described_class).to receive(:list_for_org).and_return([team_hash_0, team_hash_1]) }

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_name)

      described_class.info(path)
    end

    it "returns the selected team" do
      return_value = described_class.info(path)

      expect(return_value).to eql(team_hash_0)
    end
  end

  describe ".create" do
    let(:args) { { :name => team_name } }

    before { allow(teams_api).to receive(:create_for_org).and_return(team) }

    it "calls create_for_org on the teams_api" do
      expect(teams_api).to receive(:create_for_org).with(org_name, args)

      described_class.create(org_name, args)
    end

    it "converts the team to team hash" do
      expect(described_class).to receive(:to_hash).with(team)

      described_class.create(org_name, args)
    end

    it "returns the team hash" do
      return_value = described_class.create(org_name, args)

      expect(return_value).to eql(team_hash)
    end
  end

  describe ".delete" do
    before do
      allow(described_class).to receive(:info).and_return(team_hash)
      allow(teams_api).to receive(:delete)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(path)

      described_class.delete(path)
    end

    it "calls delete on the teams_api" do
      expect(teams_api).to receive(:delete).with(team_id)

      described_class.delete(path)
    end
  end

  describe ".api" do
    it "returns the API from the client" do
      return_value = described_class.api

      expect(return_value).to eql(teams_api)
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
      expect(users_api).to receive(:list_for_team).with(team_id)

      described_class.to_hash(team)
    end

    it "returns the hash" do
      return_value = described_class.to_hash(team)

      expect(return_value).to eql(
        :id => team_id,
        :name => team.name,
        :permission => team.permission,
        :members => "2",
        :created_at => team.created_at,
        :updated_at => team.updated_at
      )
    end
  end
end
