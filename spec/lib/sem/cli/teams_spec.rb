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

    context "organization not found" do
      before do
        stub_api(:get, "/orgs/rt/teams").to_return(404, {})
      end

      it "displays the error" do
        _stdout, stderr, status = sem_run("teams:info rt/devs")

        expect(stderr).to include("Team rt/devs not found.")
        expect(status).to eq(:fail)
      end
    end

    context "team not found" do
      before do
        stub_api(:get, "/orgs/rt/teams").to_return(200, [])
      end

      it "displays the error" do
        _stdout, stderr, status = sem_run("teams:info rt/devs")

        expect(stderr).to include("Team rt/devs not found.")
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

    context "validation fails" do
      before do
        error = { "message" => "Validation Failed. Name has already been taken." }
        stub_api(:post, "/orgs/rt/teams").to_return(422, error)
      end

      it "displays the failure" do
        _stdout, stderr, status = sem_run("teams:create rt/devs --permission edit")

        expect(stderr).to include("Validation Failed. Name has already been taken.")
        expect(status).to eq(:fail)
      end
    end

    context "invalid permission" do
      it "displays the failure" do
        _stdout, stderr, status = sem_run("teams:create rt/devs --permission owner")

        expect(stderr).to include("Permission must be one of [admin, edit, read]")
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

        error = { "message" => "Validation Failed. Name contains spaces." }
        stub_api(:patch, "/teams/#{team[:id]}").to_return(422, error)
      end

      it "displays the team" do
        _stdout, stderr, status = sem_run("teams:rename rt/devs rt/admins")

        expect(stderr).to include("Validation Failed. Name contains spaces.")
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

        stub_api(:patch, "/teams/#{team[:id]}").to_return(422, "message" => "Validation Failed")
      end

      it "displays the team" do
        _stdout, stderr, status = sem_run("teams:set-permission rt/devs --permission admin")

        expect(stderr).to include("Validation Failed")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#delete" do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
    end

    context "delete succeds" do
      before do
        stub_api(:delete, "/teams/#{team[:id]}").to_return(204, team)
      end

      it "updates the name of the team" do
        stdout, _stderr = sem_run("teams:delete rt/devs")

        expect(stdout).to include("Team rt/devs deleted")
      end
    end

    context "delete fails" do
      before do
        error = { "message" => "Team is connected to multiple projects" }
        stub_api(:delete, "/teams/#{team[:id]}").to_return(409, error)
      end

      it "updates the name of the team" do
        _stdout, stderr, status = sem_run("teams:delete rt/devs")

        expect(stderr).to include("[ERROR] Team is connected to multiple projects")
        expect(status).to eq(:fail)
      end
    end
  end

  describe Sem::CLI::Teams::Members do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
    end

    describe "#list" do
      context "team not found" do
        before do
          stub_api(:get, "/orgs/rt/teams").to_return(404, {})
        end

        it "displays team not found" do
          _stdout, stderr, status = sem_run("teams:members:list rt/devs")

          expect(stderr).to include("Team rt/devs not found")
          expect(status).to eq(:fail)
        end
      end

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
      context "user exists" do
        before do
          stub_api(:post, "/teams/#{team[:id]}/users/ijovan").to_return(204, "")
        end

        it "add a user to the team" do
          stdout, _stderr = sem_run!("teams:members:add rt/devs ijovan")

          expect(stdout).to include("User ijovan added to the team")
        end
      end

      context "user doesn't exits" do
        before do
          stub_api(:post, "/teams/#{team[:id]}/users/jojojo").to_return(404, "")
        end

        it "displays that the user is not found" do
          _stdout, stderr = sem_run("teams:members:add rt/devs jojojo")

          expect(stderr).to include("User jojojo not found")
        end
      end
    end

    describe "#remove" do
      context "user exists" do
        before do
          stub_api(:delete, "/teams/#{team[:id]}/users/ijovan").to_return(204, "")
        end

        it "remove a user from the team" do
          stdout, _stderr = sem_run!("teams:members:remove rt/devs ijovan")

          expect(stdout).to include("User ijovan removed from the team")
        end
      end

      context "user doesn't exits" do
        before do
          stub_api(:delete, "/teams/#{team[:id]}/users/jojojo").to_return(404, "")
        end

        it "displays that the user is not found" do
          _stdout, stderr = sem_run("teams:members:remove rt/devs jojojo")

          expect(stderr).to include("User jojojo not found")
        end
      end
    end
  end

  describe Sem::CLI::Teams::Projects do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
    end

    describe "#list" do
      context "when the team has several projects" do
        let(:project) { ApiResponse.project }

        before do
          stub_api(:get, "/teams/#{team[:id]}/projects").to_return(200, [project])
        end

        it "lists team members" do
          stdout, _stderr = sem_run!("teams:projects:list rt/devs")

          expect(stdout).to include(project[:id])
        end
      end

      context "when the team has no projects" do
        before do
          stub_api(:get, "/teams/#{team[:id]}/projects").to_return(200, [])
        end

        it "offers a way to add first project" do
          stdout, _stderr = sem_run!("teams:projects:list rt/devs")

          expect(stdout).to include("Add your first project")
        end
      end

      context "team does not exists" do
        before do
          stub_api(:get, "/orgs/rt/teams").to_return(200, [])
        end

        it "offers a way to add first project" do
          _stdout, stderr = sem_run("teams:projects:list rt/devs")

          expect(stderr).to include("Team rt/devs not found")
        end
      end
    end

    describe "#add" do
      let(:project) { ApiResponse.project(:name => "cli") }

      context "project exists" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:post, "/teams/#{team[:id]}/projects/#{project[:id]}").to_return(204, "")
        end

        it "add a project to the team" do
          stdout, _stderr = sem_run!("teams:projects:add rt/devs rt/cli")

          expect(stdout).to include("Project rt/cli added to the team")
        end
      end

      context "project doesn't exists" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [])
        end

        it "displays the error" do
          _stdout, stderr = sem_run("teams:projects:add rt/devs rt/cli")

          expect(stderr).to include("Project rt/cli not found")
        end
      end
    end

    describe "#remove" do
      let(:project) { ApiResponse.project(:name => "cli") }

      context "project exists" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:delete, "/teams/#{team[:id]}/projects/#{project[:id]}").to_return(204, "")
        end

        it "remove a user from the team" do
          stdout, _stderr = sem_run!("teams:projects:remove rt/devs rt/cli")

          expect(stdout).to include("Project rt/cli removed from the team")
        end
      end

      context "project doesn't exists" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [])
        end

        it "displays the error" do
          _stdout, stderr = sem_run("teams:projects:add rt/devs rt/cli")

          expect(stderr).to include("Project rt/cli not found")
        end
      end

      context "project is not part of the team" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:delete, "/teams/#{team[:id]}/projects/#{project[:id]}").to_return(404, "")
        end

        it "add a project to the team" do
          _stdout, stderr = sem_run("teams:projects:remove rt/devs rt/cli")

          expect(stderr).to include("Project rt/cli not found")
        end
      end
    end
  end

  describe Sem::CLI::Teams::Secrets do
    let(:team) { ApiResponse.team }

    before do
      stub_api(:get, "/orgs/rt/teams").to_return(200, [team])
    end

    describe "#list" do
      context "when the team has several secrets" do
        let(:secret1) { ApiResponse.secret(:name => "tokens") }
        let(:secret2) { ApiResponse.secret(:name => "secrets") }

        before do
          stub_api(:get, "/teams/#{team[:id]}/secrets").to_return(200, [secret1, secret2])

          stub_api(:get, "/secrets/#{secret1[:id]}/config_files").to_return(200, [])
          stub_api(:get, "/secrets/#{secret2[:id]}/config_files").to_return(200, [])
          stub_api(:get, "/secrets/#{secret1[:id]}/env_vars").to_return(200, [])
          stub_api(:get, "/secrets/#{secret2[:id]}/env_vars").to_return(200, [])
        end

        it "lists team's secrets" do
          stdout, _stderr = sem_run!("teams:secrets:list rt/devs")

          expect(stdout).to include(secret1[:name])
          expect(stdout).to include(secret2[:name])
        end
      end

      context "when the team has no secrets" do
        before do
          stub_api(:get, "/teams/#{team[:id]}/secrets").to_return(200, [])
        end

        it "offers a way to add first secrets" do
          stdout, _stderr = sem_run!("teams:secrets:list rt/devs")

          expect(stdout).to include("Add your first secrets")
        end
      end

      context "team not found" do
        before do
          stub_api(:get, "/orgs/rt/teams").to_return(200, [])
        end

        it "displays an error" do
          _stdout, stderr = sem_run("teams:secrets:list rt/devs")

          expect(stderr).to include("Team rt/devs not found")
        end
      end
    end

    describe "#add" do
      let(:secret) { ApiResponse.secret(:name => "tokens") }

      context "secrets exists" do
        before do
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
          stub_api(:post, "/teams/#{team[:id]}/secrets/#{secret[:id]}").to_return(204, "")
        end

        it "add secrets to the team" do
          stdout, _stderr = sem_run!("teams:secrets:add rt/devs rt/tokens")

          expect(stdout).to include("Secrets rt/tokens added to the team")
        end
      end

      context "secrets don't exist" do
        before do
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [])
        end

        it "displays and error" do
          _stdout, stderr = sem_run("teams:secrets:add rt/devs rt/tokens")

          expect(stderr).to include("Secret rt/tokens not found")
        end
      end
    end

    describe "#remove" do
      let(:secret) { ApiResponse.secret(:name => "tokens") }

      context "secrets exist" do
        before do
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
          stub_api(:delete, "/teams/#{team[:id]}/secrets/#{secret[:id]}").to_return(204, "")
        end

        it "remove a secret from the team" do
          stdout, _stderr = sem_run!("teams:secrets:remove rt/devs rt/tokens")

          expect(stdout).to include("Secrets rt/tokens removed from the team")
        end
      end

      context "secret doesn't exists" do
        before do
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [])
        end

        it "displays and error" do
          _stdout, stderr = sem_run("teams:secrets:remove rt/devs rt/tokens")

          expect(stderr).to include("Secret rt/tokens not found")
        end
      end

      context "secrets not added to the team" do
        before do
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
          stub_api(:delete, "/teams/#{team[:id]}/secrets/#{secret[:id]}").to_return(404, "")
        end

        it "displays and error" do
          _stdout, stderr = sem_run("teams:secrets:remove rt/devs rt/tokens")

          expect(stderr).to include("Secret rt/tokens not found")
        end
      end
    end
  end
end
