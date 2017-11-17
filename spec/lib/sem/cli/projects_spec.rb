require "spec_helper"

describe Sem::CLI::Projects do

  describe "#list" do
    let(:org1) { ApiResponse.organization(:username => "rt") }
    let(:org2) { ApiResponse.organization(:username => "z-fighters") }

    context "you have at least one project on semaphore" do
      let(:project1) { ApiResponse.project }
      let(:project2) { ApiResponse.project }

      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/#{org1[:username]}/projects").to_return(200, [project1])
        stub_api(:get, "/orgs/#{org2[:username]}/projects").to_return(200, [project2])
      end

      it "lists all projects" do
        stdout, _stderr = sem_run!("projects:list")

        expect(stdout).to include("rt/cli")
        expect(stdout).to include("z-fighters/cli")
      end
    end

    context "no projects on semaphore" do
      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/rt/projects").to_return(200, [])
        stub_api(:get, "/orgs/z-fighters/projects").to_return(200, [])
      end

      it "offers you to set up a project on semaphore" do
        stdout, _stderr = sem_run!("projects:list")

        expect(stdout).to include("Add your first project")
      end
    end
  end

  describe "#info" do
    context "project exists on semaphore" do
      let(:project) { ApiResponse.project }

      it "shows detailed information about a project" do
        stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])

        stdout, _stderr = sem_run!("projects:info rt/cli")

        expect(stdout).to include(project[:id])
      end
    end

    context "project not found on semaphore" do
      it "shows project not found" do
        stub_api(:get, "/orgs/rt/projects?name=cli").to_return(404, [])

        _stdout, stderr, status = sem_run("projects:info rt/cli")

        expect(stderr).to include("Project rt/cli not found")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#create" do
    context "invalid git url passed" do
      it "prints an error" do
        _stdout, stderr, status = sem_run("projects:create rt/cli --url github.com:renderedtext")

        expect(stderr).to include("Git URL github.com:renderedtext is invalid.")
        expect(status).to eq(:fail)
      end
    end

    context "git url is valid" do
      let(:project) { ApiResponse.project }

      before do
        body = {
          "repo_provider" => "github",
          "repo_owner" => "renderedtext",
          "repo_name" => "cli",
          "name" => "cli"
        }

        stub_api(:post, "/orgs/rt/projects", body).to_return(200, project)
      end

      it "creates a project" do
        stdout, _stderr = sem_run!("projects:create rt/cli --url git@github.com:renderedtext/cli.git")

        expect(stdout).to include(project[:id])
      end
    end

    context "validation error" do
      it "prints the error" do
        error = { "message" => "Validation failed. Name is already taken." }

        stub_api(:post, "/orgs/rt/projects").to_return(422, error)

        _stdout, stderr, status = sem_run("projects:create rt/cli --url git@github.com:renderedtext/cli.git")

        expect(stderr).to include("Validation failed. Name is already taken.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe Sem::CLI::Projects::Files do
    context "project exists" do
      let(:project) { ApiResponse.project(:name => "cli") }
      let(:file) { ApiResponse.file }

      before do
        stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
        stub_api(:get, "/projects/#{project[:id]}/config_files").to_return(200, [file])
      end

      it "lists files on project" do
        stdout, _stderr = sem_run!("projects:files:list rt/cli")

        expect(stdout).to include(file[:id])
      end
    end

    context "project not found" do
      before do
        stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [])
      end

      it "lists files on project" do
        _stdout, stderr, status = sem_run("projects:files:list rt/cli")

        expect(stderr).to include("Project rt/cli not found")
        expect(status).to eq(:fail)
      end
    end
  end

  describe Sem::CLI::Projects::EnvVars do
    let(:project) { ApiResponse.project(:name => "cli") }
    let(:env_var) { ApiResponse.env_var }

    before do
      stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
      stub_api(:get, "/projects/#{project[:id]}/env_vars").to_return(200, [env_var])
    end

    it "lists files on project" do
      stdout, _stderr = sem_run!("projects:env-vars:list rt/cli")

      expect(stdout).to include(env_var[:id])
    end

    context "invalid git url" do
      it "prints error" do
        stdout, stderr, status = sem_run("projects:create renderedtext/api-2 --url lol")

        msg = [
          "Git URL lol is invalid."
        ]

        expect(stderr.strip).to eq(msg.join("\n"))
        expect(stdout).to eq("")
        expect(status).to eq(:fail)
      end
    end
  end

  describe Sem::CLI::Projects::Secrets do
    let(:project) { ApiResponse.project(:name => "cli") }

    describe "#list" do
      context "you have at least one secret attached to a project" do
        let(:secret1) { ApiResponse.secret }
        let(:secret2) { ApiResponse.secret }

        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:get, "/projects/#{project[:id]}/secrets").to_return(200, [secret1, secret2])

          stub_api(:get, "/secrets/#{secret1[:id]}/config_files").to_return(200, [])
          stub_api(:get, "/secrets/#{secret2[:id]}/config_files").to_return(200, [])

          stub_api(:get, "/secrets/#{secret1[:id]}/env_vars").to_return(200, [])
          stub_api(:get, "/secrets/#{secret2[:id]}/env_vars").to_return(200, [])
        end

        it "lists all secrets on the project" do
          stdout, _stderr = sem_run!("projects:secrets:list rt/cli")

          expect(stdout).to include(secret1[:id])
          expect(stdout).to include(secret2[:id])
        end
      end

      context "no secret attached to the project" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:get, "/projects/#{project[:id]}/secrets").to_return(200, [])
        end

        it "offers you to create and attach a secret" do
          stdout, _stderr = sem_run!("projects:secrets:list rt/cli")

          expect(stdout).to include("Add your first secret")
        end
      end
    end

    describe "#add" do
      context "secret exists" do
        let(:secret) { ApiResponse.secret(:name => "tokens") }
        let(:file) { ApiResponse.file }
        let(:env_var) { ApiResponse.env_var }

        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
          stub_api(:post, "/projects/#{project[:id]}/secrets/#{secret[:id]}").to_return(204, "")

          stub_api(:get, "/secrets/#{secret[:id]}/config_files").to_return(200, [file])
          stub_api(:get, "/secrets/#{secret[:id]}/env_vars").to_return(200, [env_var])
        end

        it "adds the secret to the project" do
          stdout, _stderr = sem_run!("projects:secrets:add rt/cli rt/tokens")

          expect(stdout).to include("Secret rt/tokens added to the project.")
        end
      end

      context "secret not found" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [])
        end

        it "displays error" do
          _stdout, stderr, status = sem_run("projects:secrets:add rt/cli rt/tokens")

          expect(stderr).to include("Secret rt/tokens not found")
          expect(status).to eq(:fail)
        end
      end
    end

    describe "#remove" do
      let(:secret) { ApiResponse.secret(:name => "tokens") }

      context "secret exists" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])

          stub_api(:delete, "/projects/#{project[:id]}/secrets/#{secret[:id]}").to_return(204, "")
        end

        it "adds the secret to the project" do
          stdout, _stderr = sem_run!("projects:secrets:remove rt/cli rt/tokens")

          expect(stdout).to include("Secret rt/tokens removed from the project.")
        end
      end

      context "secret not attached to project" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])

          stub_api(:delete, "/projects/#{project[:id]}/secrets/#{secret[:id]}").to_return(404, "")
        end

        it "displays error" do
          _stdout, stderr, status = sem_run("projects:secrets:remove rt/cli rt/tokens")

          expect(stderr).to include("Secret rt/tokens not found")
          expect(status).to eq(:fail)
        end
      end

      context "secret not found" do
        before do
          stub_api(:get, "/orgs/rt/projects?name=cli").to_return(200, [project])
          stub_api(:get, "/orgs/rt/secrets").to_return(200, [])
        end

        it "displays error" do
          _stdout, stderr, status = sem_run("projects:secrets:add rt/cli rt/tokens")

          expect(stderr).to include("Secret rt/tokens not found")
          expect(status).to eq(:fail)
        end
      end
    end

  end

end
