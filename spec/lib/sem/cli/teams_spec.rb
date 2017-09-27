require "spec_helper"

describe Sem::CLI::Teams do
  let(:team) { ApiResponse.team }

  describe "#list" do
    let(:org1) { ApiResponse.organization(:username => "rt") }
    let(:org2) { ApiResponse.organization(:username => "z-fighters") }

    context "when the user has no teams" do
      let(:team1) { ApiResponse.team(:name => "team-a") }
      let(:team2) { ApiResponse.team(:name => "team-b") }

      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/#{org1[:username]}/teams").to_return(200, [team1])
        stub_api(:get, "/orgs/#{org2[:username]}/teams").to_return(200, [team2])

        stub_api(:get, "/teams/#{team1[:id]}/users").to_return(200, [])
        stub_api(:get, "/teams/#{team2[:id]}/users").to_return(200, [])
      end

      it "lists the teams" do
        stdout, _stderr = sem_run!("teams:list")

        expect(stdout).to include(team1[:name])
        expect(stdout).to include(team2[:name])
      end
    end

    context "when the user has so many teams that it needs to be paginated via api" do
      let(:team1) { ApiResponse.team(:name => "team-a") }
      let(:team2) { ApiResponse.team(:name => "team-b") }

      before do
        stub_api(:get, "/orgs").to_return(200, [org1])

        next_link = "<https://api.semaphoreci.com/v2/orgs/#{org1[:username]}/teams?page=2>; rel=\"next\""
        stub_api(:get, "/orgs/#{org1[:username]}/teams").to_return(200, [team1], "Link" => next_link)
        stub_api(:get, "/orgs/#{org1[:username]}/teams?page=2").to_return(200, [team2])

        stub_api(:get, "/teams/#{team1[:id]}/users").to_return(200, [])
        stub_api(:get, "/teams/#{team2[:id]}/users").to_return(200, [])
      end

      it "lists all teams" do
        stdout, _stderr = sem_run!("teams:list")

        expect(stdout).to include(team1[:name])
        expect(stdout).to include(team2[:name])
      end
    end

    context "when the user has at least one team" do
      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/#{org1[:username]}/teams").to_return(200, [])
        stub_api(:get, "/orgs/#{org2[:username]}/teams").to_return(200, [])
      end

      it "lists all teams" do
        stdout, _stderr = sem_run!("teams:list")

        expect(stdout).to include("Create your first team")
      end
    end
  end

  describe "#info" do
    context "the team exists" do
      let(:team) { ApiResponse.team(:name => "devs") }
      let(:user) { ApiResponse.user }

      before do
        stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
        stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [user])
      end

      it "shows detailed information about a project" do
        stdout, _stderr = sem_run!("teams:info rt/devs")

        expect(stdout).to include(team[:id])
      end
    end

    context "team not found" do
      before do
        stub_api(:get, "/orgs/rt/teams").to_return(200, [])
      end

      it "displays the error" do
        stdout, _stderr, status = sem_run("teams:info rt/devs")

        expect(stdout).to include("Team rt/devs not found.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#create" do
    context "creation succeds" do
      let(:team) { ApiResponse.team }
      let(:user) { ApiResponse.user }

      before do
        stub_api(:post, "/orgs/rt/teams").to_return(200, team)
        stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [user])
      end

      it "displays the teams info" do
        stdout, _stderr = sem_run!("teams:create rt/devs --permission admin")

        expect(stdout).to include(team[:id])
      end
    end

    context "creation failes" do
      before do
        stub_api(:post, "/orgs/rt/teams").to_return(422, {})
      end

      it "displays the failure" do
        stdout, _stderr, status = sem_run("teams:create rt/devs --permission owner")

        expect(stdout).to include("Team rt/devs not created.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#rename" do
    context "update succeds" do
      let(:team) { ApiResponse.team }
      let(:user) { ApiResponse.user }

      before do
        stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
        stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [user])

        stub_api(:patch, "/teams/#{team[:id]}", :name => "admins").to_return(200, team)
      end

      it "displays the team" do
        stdout, _stderr = sem_run!("teams:rename rt/devs rt/admins")

        expect(stdout).to include(team[:id])
      end
    end

    context "update fails" do
      let(:team) { ApiResponse.team }
      let(:user) { ApiResponse.user }

      before do
        stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
        stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [user])

        stub_api(:patch, "/teams/#{team[:id]}").to_return(422, {})
      end

      it "displays the team" do
        stdout, _stderr, status = sem_run("teams:rename rt/devs rt/admins")

        expect(stdout).to include("Team rt/devs not updated.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#set-permission" do
    context "update succeds" do
      let(:team) { ApiResponse.team }
      let(:user) { ApiResponse.user }

      before do
        stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
        stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [user])

        stub_api(:patch, "/teams/#{team[:id]}").to_return(200, team)
      end

      it "displays the team" do
        stdout, _stderr = sem_run!("teams:set-permission rt/devs --permission admin")

        expect(stdout).to include(team[:id])
      end
    end

    context "update fails" do
      let(:team) { ApiResponse.team }
      let(:user) { ApiResponse.user }

      before do
        stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
        stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [user])

        stub_api(:patch, "/teams/#{team[:id]}").to_return(422, {})
      end

      it "displays the team" do
        stdout, _stderr, status = sem_run("teams:set-permission rt/devs --permission admin")

        expect(stdout).to include("Team rt/devs not updated.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#delete" do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
      stub_api(:delete, "/teams/#{team[:id]}").to_return(204, team)
    end

    it "updates the name of the team" do
      stdout, _stderr = sem_run("teams:delete rt/devs")

      expect(stdout).to include("Team rt/devs deleted")
    end
  end

  describe Sem::CLI::Teams::Members do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
    end

    describe "#list" do
      context "when the team has several members" do
        let(:user1) { ApiResponse.user }
        let(:user2) { ApiResponse.user }

        before do
          stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [user1, user2])
        end

        it "lists team members" do
          stdout, _stderr = sem_run!("teams:members:list rt/devs")

          expect(stdout).to include(user1[:username])
          expect(stdout).to include(user2[:username])
        end
      end

      context "when the team has no members" do
        before do
          stub_api(:get, "/teams/#{team[:id]}/users").to_return(200, [])
        end

        it "offers a way to add first user" do
          stdout, _stderr = sem_run!("teams:members:list rt/devs")

          expect(stdout).to include("Add your first member")
        end
      end
    end

    describe "#add" do
      before do
        stub_api(:post, "/teams/#{team[:id]}/users/ijovan").to_return(204, "")
      end

      it "add a user to the team" do
        stdout, _stderr = sem_run!("teams:members:add rt/devs ijovan")

        expect(stdout).to include("User ijovan added to the team")
      end
    end

    describe "#remove" do
      before do
        stub_api(:delete, "/teams/#{team[:id]}/users/ijovan").to_return(204, "")
      end

      it "remove a user from the team" do
        stdout, _stderr = sem_run!("teams:members:remove rt/devs ijovan")

        expect(stdout).to include("User ijovan removed from the team")
      end
    end
  end

  describe Sem::CLI::Teams::Projects do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
    end

    describe "#list" do
      context "when the team has several members" do
        let(:project) { ApiResponse.project }

        before do
          stub_api(:get, "/teams/#{team[:id]}/projects").to_return(200, [project])
        end

        it "lists team members" do
          stdout, _stderr = sem_run!("teams:projects:list rt/devs")

          expect(stdout).to include(project[:id])
        end
      end

      context "when the team has no members" do
        before do
          stub_api(:get, "/teams/#{team[:id]}/projects").to_return(200, [])
        end

        it "offers a way to add first project" do
          stdout, _stderr = sem_run!("teams:projects:list rt/devs")

          expect(stdout).to include("Add your first project")
        end
      end
    end

    describe "#add" do
      let(:project) { ApiResponse.project(:name => "cli") }

      before do
        stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
        stub_api(:post, "/teams/#{team[:id]}/projects/#{project[:id]}").to_return(204, "")
      end

      it "add a project to the team" do
        stdout, _stderr = sem_run!("teams:projects:add rt/devs rt/cli")

        expect(stdout).to include("Project rt/cli added to the team")
      end
    end

    describe "#remove" do
      let(:project) { ApiResponse.project(:name => "cli") }

      before do
        stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
        stub_api(:delete, "/teams/#{team[:id]}/projects/#{project[:id]}").to_return(204, "")
      end

      it "remove a user from the team" do
        stdout, _stderr = sem_run!("teams:projects:remove rt/devs rt/cli")

        expect(stdout).to include("Project rt/cli removed from the team")
      end
    end
  end

  describe Sem::CLI::Teams::SharedConfigs do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
    end

    describe "#list" do
      context "when the team has several shared configs" do
        let(:config1) { ApiResponse.shared_config(:name => "tokens") }
        let(:config2) { ApiResponse.shared_config(:name => "secrets") }

        before do
          stub_api(:get, "/teams/#{team[:id]}/shared_configs").to_return(200, [config1, config2])

          stub_api(:get, "/shared_configs/#{config1[:id]}/config_files").to_return(200, [])
          stub_api(:get, "/shared_configs/#{config2[:id]}/config_files").to_return(200, [])
          stub_api(:get, "/shared_configs/#{config1[:id]}/env_vars").to_return(200, [])
          stub_api(:get, "/shared_configs/#{config2[:id]}/env_vars").to_return(200, [])
        end

        it "lists team's shared configs" do
          stdout, _stderr = sem_run!("teams:shared-configs:list rt/devs")

          expect(stdout).to include(config1[:name])
          expect(stdout).to include(config2[:name])
        end
      end

      context "when the team has no members" do
        before do
          stub_api(:get, "/teams/#{team[:id]}/shared_configs").to_return(200, [])
        end

        it "offers a way to add first project" do
          stdout, _stderr = sem_run!("teams:shared-configs:list rt/devs")

          expect(stdout).to include("Add your first shared configuration")
        end
      end
    end

    describe "#add" do
      let(:config) { ApiResponse.shared_config(:name => "tokens") }

      before do
        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [config])
        stub_api(:post, "/teams/#{team[:id]}/shared_configs/#{config[:id]}").to_return(204, "")
      end

      it "add a shared_config to the team" do
        stdout, _stderr = sem_run!("teams:shared-configs:add rt/devs rt/tokens")

        expect(stdout).to include("Shared Configuration rt/tokens added to the team")
      end
    end

    describe "#remove" do
      let(:config) { ApiResponse.shared_config(:name => "tokens") }

      before do
        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [config])
        stub_api(:delete, "/teams/#{team[:id]}/shared_configs/#{config[:id]}").to_return(204, "")
      end

      it "remove a shared_config from the team" do
        stdout, _stderr = sem_run!("teams:shared-configs:remove rt/devs rt/tokens")

        expect(stdout).to include("Shared Configuration rt/tokens removed from the team")
      end
    end
  end
end
