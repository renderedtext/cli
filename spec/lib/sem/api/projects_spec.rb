require "spec_helper"

describe Sem::API::Projects do
  let(:sem_api_projects) { subject }

  let(:projects_api) { instance_double(SemaphoreClient::Api::Project) }
  let(:client) { instance_double(SemaphoreClient, :projects => projects_api) }

  let(:team_path) { "org/team" }

  let(:project_id) { 0 }
  let(:project_hash) { { :id => project_id } }

  let(:project) { instance_double(SemaphoreClient::Model::Project, :id => 0, :name => "name") }

  before do
    allow(sem_api_projects).to receive(:client).and_return(client)
    allow(sem_api_projects).to receive(:to_hash).and_return(project_hash)
    allow(described_class).to receive(:new).and_return(sem_api_projects)
  end

  describe ".list" do
    before { allow(sem_api_projects).to receive(:list).and_return([project_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list
    end

    it "passes the call to the instance" do
      expect(sem_api_projects).to receive(:list)

      described_class.list
    end

    it "returns the result" do
      return_value = described_class.list

      expect(return_value).to eql([project_hash])
    end
  end

  describe ".list_for_org" do
    let(:org_name) { "org" }

    before { allow(sem_api_projects).to receive(:list_for_org).and_return([project_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list_for_org(org_name)
    end

    it "passes the call to the instance" do
      expect(sem_api_projects).to receive(:list_for_org).with(org_name)

      described_class.list_for_org(org_name)
    end

    it "returns the result" do
      return_value = described_class.list_for_org(org_name)

      expect(return_value).to eql([project_hash])
    end
  end

  describe ".list_for_team" do
    before { allow(sem_api_projects).to receive(:list_for_team).and_return([project_hash]) }

    it "creates an instance" do
      expect(described_class).to receive(:new)

      described_class.list_for_team(team_path)
    end

    it "passes the call to the instance" do
      expect(sem_api_projects).to receive(:list_for_team).with(team_path)

      described_class.list_for_team(team_path)
    end

    it "returns the result" do
      return_value = described_class.list_for_team(team_path)

      expect(return_value).to eql([project_hash])
    end
  end

  describe "#list" do
    let(:org_username) { "org" }
    let(:org) { { :username => org_username } }

    before do
      allow(Sem::API::Orgs).to receive(:list).and_return([org])
      allow(sem_api_projects).to receive(:list_for_org).and_return([project_hash])
    end

    it "calls list on the sem_api_orgs" do
      expect(Sem::API::Orgs).to receive(:list)

      sem_api_projects.list
    end

    it "calls list_for_org on the subject" do
      expect(sem_api_projects).to receive(:list_for_org).with(org_username)

      sem_api_projects.list
    end

    it "returns the project hashes" do
      return_value = sem_api_projects.list

      expect(return_value).to eql([project_hash])
    end
  end

  describe "#list_for_org" do
    let(:org_username) { "org" }

    before { allow(projects_api).to receive(:list_for_org).and_return([project]) }

    it "calls list_for_org on the projects_api" do
      expect(projects_api).to receive(:list_for_org).with(org_username)

      sem_api_projects.list_for_org(org_username)
    end

    it "converts the projects to project hashes" do
      expect(sem_api_projects).to receive(:to_hash).with(project)

      sem_api_projects.list_for_org(org_username)
    end

    it "returns the project hashes" do
      return_value = sem_api_projects.list_for_org(org_username)

      expect(return_value).to eql([project_hash])
    end
  end

  describe "#to_hash" do
    before { allow(sem_api_projects).to receive(:to_hash).and_call_original }

    it "returns the hash" do
      return_value = sem_api_projects.send(:to_hash, project)

      expect(return_value).to eql(:id => 0, :name => "name")
    end
  end

  describe "#list_for_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(projects_api).to receive(:list_for_team).and_return([project])
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      sem_api_projects.list_for_team(team_path)
    end

    it "calls list_for_team on the projects_api" do
      expect(projects_api).to receive(:list_for_team).with(team_id)

      sem_api_projects.list_for_team(team_path)
    end

    it "converts the projects to project hashes" do
      expect(sem_api_projects).to receive(:to_hash).with(project)

      sem_api_projects.list_for_team(team_path)
    end

    it "returns the user hashes" do
      return_value = sem_api_projects.list_for_team(team_path)

      expect(return_value).to eql([project_hash])
    end
  end
end
