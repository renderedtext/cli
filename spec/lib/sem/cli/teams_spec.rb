require "spec_helper"

describe Sem::CLI::Teams do
  let(:team) { StubFactory.team }

  describe "#list" do
    context "when the user has no teams" do
      before do
        allow(Sem::API::Team).to receive(:all).and_return([])
      end

      it "offers the setup of the first team" do
        expect(Sem::Views::Teams).to receive(:create_first_team)

        sem_run("teams:list")
      end
    end

    context "when the user has at least one team" do
      before do
        allow(Sem::API::Team).to receive(:all).and_return([team])
      end

      it "lists all teams" do
        expect(Sem::Views::Teams).to receive(:list).with([team])

        sem_run("teams:list")
      end
    end
  end

  describe "#info" do
    before { allow(Sem::API::Team).to receive(:find!).with("rt/devs").and_return(team) }

    it "shows detailed information about a project" do
      expect(Sem::Views::Teams).to receive(:info).with(team)

      sem_run("teams:info rt/devs")
    end
  end

  describe "#create" do
    context "permission level is passed" do
      it "creates a new team with the passed permission level" do
        expect(Sem::API::Team).to receive(:create!).with("rt/devs", :permission => "admin").and_return(team)
        expect(Sem::Views::Teams).to receive(:info).with(team)

        sem_run("teams:create rt/devs --permission admin")
      end
    end

    context "permission level is not passed" do
      it "creates a new team with the read permissions" do
        expect(Sem::API::Team).to receive(:create!).with("rt/devs", :permission => "read").and_return(team)
        expect(Sem::Views::Teams).to receive(:info).with(team)

        sem_run("teams:create rt/devs")
      end
    end
  end

  describe "#rename" do
    before do
      allow(Sem::API::Team).to receive(:find!).with("rt/devs").and_return(team)
    end

    it "updates the name of the team" do
      expect(team).to receive(:update).with(:name => "rt/admins").and_return(team)
      expect(Sem::Views::Teams).to receive(:info).with(team)

      sem_run("teams:rename rt/devs rt/admins")
    end
  end

  describe "#set-permission" do
    before do
      allow(Sem::API::Team).to receive(:find!).with("rt/devs").and_return(team)
    end

    it "updates the name of the team" do
      expect(team).to receive(:update).with(:permission => "admin").and_return(team)
      expect(Sem::Views::Teams).to receive(:info).with(team)

      sem_run("teams:set-permission rt/devs --permission admin")
    end
  end

  describe "#delete" do
    before do
      allow(Sem::API::Team).to receive(:find!).with("rt/devs").and_return(team)
    end

    it "updates the name of the team" do
      expect(team).to receive(:delete!)

      sem_run("teams:delete rt/devs")
    end
  end

  describe Sem::CLI::Teams::Members do

    let(:user) { StubFactory.user }

    before do
      allow(Sem::API::Team).to receive(:find!).with("rt/devs").and_return(team)
    end

    describe "#list" do
      context "when the team has several members" do
        before { allow(team).to receive(:users).and_return([user]) }

        it "lists team members" do
          expect(Sem::Views::Users).to receive(:list).with([user]).and_call_original

          sem_run("teams:members:list rt/devs")
        end
      end

      context "when the team has no members" do
        before { allow(team).to receive(:users).and_return([]) }

        it "offers a way to add first user" do
          expect(Sem::Views::Teams).to receive(:add_first_team_member).with(team)

          sem_run("teams:members:list rt/devs")
        end
      end
    end

    describe "#add" do
      it "add a user to the team" do
        expect(team).to receive(:add_user).with("ijovan")

        sem_run("teams:members:add rt/devs ijovan")
      end
    end

    describe "#remove" do
      it "remove a user from the team" do
        expect(team).to receive(:remove_user).with("ijovan")

        sem_run("teams:members:remove rt/devs ijovan")
      end
    end
  end

  describe Sem::CLI::Teams::Projects do
    let(:team) { StubFactory.team }
    let(:project) { StubFactory.project }

    before do
      allow(Sem::API::Team).to receive(:find!).with("rt/devs").and_return(team)
      allow(Sem::API::Project).to receive(:find!).with("rt/cli").and_return(project)
    end

    describe "#list" do
      context "when the team has several members" do
        before { allow(team).to receive(:projects).and_return([project]) }

        it "lists team members" do
          expect(Sem::Views::Projects).to receive(:list).with([project]).and_call_original

          sem_run("teams:projects:list rt/devs")
        end
      end

      context "when the team has no members" do
        before { allow(team).to receive(:projects).and_return([]) }

        it "offers a way to add first project" do
          expect(Sem::Views::Teams).to receive(:add_first_project).with(team).and_call_original

          sem_run("teams:projects:list rt/devs")
        end
      end
    end

    describe "#add" do
      it "add a project to the team" do
        expect(team).to receive(:add_project).with(project)

        sem_run("teams:projects:add rt/devs rt/cli")
      end
    end

    describe "#remove" do
      it "remove a user from the team" do
        expect(team).to receive(:remove_project).with(project)

        sem_run("teams:projects:remove rt/devs rt/cli")
      end
    end
  end

  describe Sem::CLI::Teams::SharedConfigs do
    let(:team) { StubFactory.team }
    let(:shared_config) { StubFactory.project }

    before do
      allow(Sem::API::Team).to receive(:find!).with("rt/devs").and_return(team)
      allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
    end

    describe "#list" do
      context "when the team has several shared configs" do
        before { allow(team).to receive(:shared_configs).and_return([shared_config]) }

        it "lists team's shared configs" do
          expect(Sem::Views::SharedConfigs).to receive(:list).with([shared_config])

          sem_run("teams:shared-configs:list rt/devs")
        end
      end

      context "when the team has no members" do
        before { allow(team).to receive(:shared_configs).and_return([]) }

        it "offers a way to add first project" do
          expect(Sem::Views::Teams).to receive(:add_first_shared_config).with(team).and_call_original

          sem_run("teams:shared-configs:list rt/devs")
        end
      end
    end

    describe "#add" do
      it "add a shared_config to the team" do
        expect(team).to receive(:add_shared_config).with(shared_config)

        sem_run("teams:shared-configs:add rt/devs rt/tokens")
      end
    end

    describe "#remove" do
      it "remove a shared_config from the team" do
        expect(team).to receive(:remove_shared_config).with(shared_config)

        sem_run("teams:shared-configs:remove rt/devs rt/tokens")
      end
    end
  end
end
