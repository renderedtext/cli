require "spec_helper"

describe Sem::API::Teams do
  let(:teams_api) { double(SemaphoreClient::Api::Team) }
  let(:users_api) { double(SemaphoreClient::Api::User) }

  let(:client) { double(SemaphoreClient, :teams => teams_api, :users => users_api) }

  let(:org_name) { "org_0" }
  let(:team_name) { "team_0" }
  let(:path) { "#{org_name}/#{team_name}" }

  let(:team_id) { 0 }
  let(:team_hash) { { :id => team_id } }

  context "static public interface" do
    before { allow(described_class).to receive(:new).and_return(subject) }

    describe ".list" do
      before { allow(subject).to receive(:list).and_return([team_hash]) }

      it "creates an instance" do
        expect(described_class).to receive(:new)

        described_class.list
      end

      it "passes the call to the instance" do
        expect(subject).to receive(:list)

        described_class.list
      end

      it "returns the result" do
        return_value = described_class.list

        expect(return_value).to eql([team_hash])
      end
    end

    describe ".info" do
      before { allow(subject).to receive(:info).and_return(team_hash) }

      it "creates an instance" do
        expect(described_class).to receive(:new)

        described_class.info(path)
      end

      it "passes the call to the instance" do
        expect(subject).to receive(:info).with(path)

        described_class.info(path)
      end

      it "returns the result" do
        return_value = described_class.info(path)

        expect(return_value).to eql(team_hash)
      end
    end

    describe ".create" do
      let(:args) { { :name => team_name } }

      before { allow(subject).to receive(:create).and_return(team_hash) }

      it "creates an instance" do
        expect(described_class).to receive(:new)

        described_class.create(org_name, args)
      end

      it "passes the call to the instance" do
        expect(subject).to receive(:create).with(org_name, args)

        described_class.create(org_name, args)
      end

      it "returns the result" do
        return_value = described_class.create(org_name, args)

        expect(return_value).to eql(team_hash)
      end
    end

    describe ".delete" do
      before { allow(subject).to receive(:delete) }

      it "creates an instance" do
        expect(described_class).to receive(:new)

        described_class.delete(path)
      end

      it "passes the call to the instance" do
        expect(subject).to receive(:delete).with(path)

        described_class.delete(path)
      end
    end
  end

  context "instance public interface" do
    let(:team) { double(SemaphoreClient::Model::Team, :id => team_id) }

    before do
      allow(subject).to receive(:client).and_return(client)
      allow(subject).to receive(:team_hash).and_return(team_hash)
    end

    describe "#list" do
      let(:org_id) { 0 }
      let(:org) { double(SemaphoreClient::Model::Org, :id => org_id) }
      let(:orgs_api) { double(SemaphoreClient::Api::Org, :list => [org]) }

      before do
        allow(teams_api).to receive(:list_for_org).and_return([team])
        allow(client).to receive(:orgs).and_return(orgs_api)
      end

      it "calls list on the orgs_api" do
        expect(orgs_api).to receive(:list)

        subject.list
      end

      it "calls list_for_org on the teams_api" do
        expect(teams_api).to receive(:list_for_org).with(org_id)

        subject.list
      end

      it "converts the teams to team hashes" do
        expect(subject).to receive(:team_hash).with(team)

        subject.list
      end

      it "returns the team hashes" do
        return_value = subject.list

        expect(return_value).to eql([team_hash])
      end
    end

    describe "#info" do
      let(:team_hash_0) { { :name => team_name } }
      let(:team_hash_1) { { :name => "team_1" } }

      before { allow(subject).to receive(:list).and_return([team_hash_0, team_hash_1]) }

      it "calls list on the subject" do
        expect(subject).to receive(:list).with(org_name)

        subject.info(path)
      end

      it "returns the selected team" do
        return_value = subject.info(path)

        expect(return_value).to eql(team_hash_0)
      end
    end

    describe "#create" do
      let(:args) { { :name => team_name } }

      before { allow(teams_api).to receive(:create_for_org).and_return(team) }

      it "calls create_for_org on the teams_api" do
        expect(teams_api).to receive(:create_for_org).with(org_name, args)

        subject.create(org_name, args)
      end

      it "converts the team to team hash" do
        expect(subject).to receive(:team_hash).with(team)

        subject.create(org_name, args)
      end

      it "returns the team hash" do
        return_value = subject.create(org_name, args)

        expect(return_value).to eql(team_hash)
      end
    end

    describe "#delete" do
      before do
        allow(subject).to receive(:info).and_return(team)
        allow(teams_api).to receive(:delete)
      end

      it "calls info on the subject" do
        expect(subject).to receive(:info).with(path)

        subject.delete(path)
      end

      it "calls delete on the teams_api" do
        expect(teams_api).to receive(:delete).with(team_id)

        subject.delete(path)
      end
    end
  end

  context "private methods" do
    describe "#team_hash" do
      let(:team) do
        double(SemaphoreClient::Model::Team, :id => team_id,
               :name => "team_0", :permission => "read",
               :created_at => 123, :updated_at => 456)
      end

      before do
        allow(users_api).to receive(:list_for_team).and_return(["user_0", "user_1"])
        allow(subject).to receive(:client).and_return(client)
      end

      it "lists the users" do
        expect(users_api).to receive(:list_for_team).with(team_id)

        subject.send(:team_hash, team)
      end

      it "returns the hash" do
        return_value = subject.send(:team_hash, team)

        expect(return_value).to eql(
          :id => team_id,
          :name => team.name,
          :permission => team.permission,
          :members => 2,
          :created_at => team.created_at,
          :updated_at => team.updated_at
        )
      end
    end
  end
end
