require "spec_helper"

describe Sem::API::Projects do
  let(:projects_api) { instance_double(SemaphoreClient::Api::Project) }
  let(:client) { instance_double(SemaphoreClient, :projects => projects_api) }

  let(:org_name) { "org" }
  let(:project_path) { "#{org_name}/project" }
  let(:team_path) { "#{org_name}/team" }

  let(:project_id) { 0 }
  let(:project_name) { "project" }
  let(:project_hash) { { :id => project_id } }

  let(:project) { instance_double(SemaphoreClient::Model::Project, :id => project_id, :name => project_name) }

  before do
    allow(described_class).to receive(:client).and_return(client)
    allow(described_class).to receive(:to_hash).and_return(project_hash)
  end

  describe ".list" do
    let(:org_username) { "org" }
    let(:org) { { :username => org_username } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(described_class).to receive(:list_for_org).and_return([project_hash])
    end

    it "calls list on the sem_api_orgs" do
      expect(Sem::API::Orgs).to receive(:list)

      described_class.list
    end

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_username)

      described_class.list
    end

    it "returns the project hashes" do
      return_value = described_class.list

      expect(return_value).to eql([project_hash])
    end
  end

  describe ".list_for_org" do
    before { allow(projects_api).to receive(:list_for_org).and_return([project]) }

    it "calls list_for_org on the projects_api" do
      expect(projects_api).to receive(:list_for_org).with(org_name)

      described_class.list_for_org(org_name)
    end

    it "converts the projects to project hashes" do
      expect(described_class).to receive(:to_hash).with(project)

      described_class.list_for_org(org_name)
    end

    it "returns the project hashes" do
      return_value = described_class.list_for_org(org_name)

      expect(return_value).to eql([project_hash])
    end
  end

  describe ".list_for_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(projects_api).to receive(:list_for_team).and_return([project])
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.list_for_team(team_path)
    end

    it "calls list_for_team on the projects_api" do
      expect(projects_api).to receive(:list_for_team).with(team_id)

      described_class.list_for_team(team_path)
    end

    it "converts the projects to project hashes" do
      expect(described_class).to receive(:to_hash).with(project)

      described_class.list_for_team(team_path)
    end

    it "returns the user hashes" do
      return_value = described_class.list_for_team(team_path)

      expect(return_value).to eql([project_hash])
    end
  end

  describe ".info" do
    let(:project_hash_0) { { :name => project_name } }
    let(:project_hash_1) { { :name => "project_1" } }

    before { allow(described_class).to receive(:list_for_org).and_return([project_hash_0, project_hash_1]) }

    it "calls list_for_org on the described class" do
      expect(described_class).to receive(:list_for_org).with(org_name)

      described_class.info(project_path)
    end

    it "returns the selected project" do
      return_value = described_class.info(project_path)

      expect(return_value).to eql(project_hash_0)
    end
  end

  describe ".add_to_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(described_class).to receive(:info).and_return(project_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(projects_api).to receive(:attach_to_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(project_path)

      described_class.add_to_team(team_path, project_path)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.add_to_team(team_path, project_path)
    end

    it "calls attach_to_team on the projects_api" do
      expect(projects_api).to receive(:attach_to_team).with(project_id, team_id)

      described_class.add_to_team(team_path, project_path)
    end
  end

  describe ".remove_from_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(described_class).to receive(:info).and_return(project_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(projects_api).to receive(:detach_from_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(project_path)

      described_class.remove_from_team(team_path, project_path)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.remove_from_team(team_path, project_path)
    end

    it "calls detach_from_team on the projects_api" do
      expect(projects_api).to receive(:detach_from_team).with(project_id, team_id)

      described_class.remove_from_team(team_path, project_path)
    end
  end

  describe ".api" do
    it "returns the API from the client" do
      return_value = described_class.api

      expect(return_value).to eql(projects_api)
    end
  end

  describe ".to_hash" do
    before { allow(described_class).to receive(:to_hash).and_call_original }

    it "returns the hash" do
      return_value = described_class.to_hash(project)

      expect(return_value).to eql(:id => 0, :name => "project")
    end
  end
end
