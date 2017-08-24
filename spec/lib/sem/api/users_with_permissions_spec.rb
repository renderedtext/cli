require "spec_helper"

describe Sem::API::UsersWithPermissions do
  let(:users_api) { instance_double(SemaphoreClient::Api::User) }
  let(:teams_api) { instance_double(SemaphoreClient::Api::Team) }
  let(:client) { instance_double(SemaphoreClient, :users => users_api, :teams => teams_api) }

  let(:org_name) { "org" }

  let(:user_hash) { { :id => "ijovan" } }

  before { allow(described_class).to receive(:client).and_return(client) }

  describe ".list_owners_for_org" do
    before { allow(Sem::API::Orgs).to receive(:list_owners).with(org_name).and_return([user_hash]) }

    it "returns the owners with permissions" do
      return_value = described_class.list_owners_for_org(org_name)

      expect(return_value).to eql([{ :id => "ijovan", :permission => "owner" }])
    end
  end

  describe ".list_admins_for_org" do
    before { allow(Sem::API::Orgs).to receive(:list_admins).with(org_name).and_return([user_hash]) }

    it "returns the admins with permissions" do
      return_value = described_class.list_admins_for_org(org_name)

      expect(return_value).to eql([{ :id => "ijovan", :permission => "admin" }])
    end
  end

  describe ".list_for_org" do
    let(:user_0) { instance_double(SemaphoreClient::Model::User, :username => "user_0") }
    let(:user_1) { instance_double(SemaphoreClient::Model::User, :username => "user_1") }
    let(:user_2) { instance_double(SemaphoreClient::Model::User, :username => "user_2") }

    let(:team_0) { instance_double(SemaphoreClient::Model::Team, :id => 0, :permission => "admin") }
    let(:team_1) { instance_double(SemaphoreClient::Model::Team, :id => 1, :permission => "edit") }
    let(:team_2) { instance_double(SemaphoreClient::Model::Team, :id => 2, :permission => "read") }

    before do
      allow(users_api).to receive(:list_for_team).with(team_0.id).and_return([user_0])
      allow(users_api).to receive(:list_for_team).with(team_1.id).and_return([user_0, user_1])
      allow(users_api).to receive(:list_for_team).with(team_2.id).and_return([user_0, user_1, user_2])

      allow(teams_api).to receive(:list_for_org).with(org_name).and_return([team_0, team_1, team_2])
    end

    it "returns the users with their max permissions" do
      return_value = described_class.list_for_org(org_name)

      expect(return_value).to eql([
        { :id => "user_0", :permission => "admin" },
        { :id => "user_1", :permission => "edit" },
        { :id => "user_2", :permission => "read" }
      ])
    end
  end
end
