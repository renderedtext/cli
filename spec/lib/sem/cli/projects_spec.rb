require "spec_helper"

describe Sem::CLI::Projects do

  describe "#list" do
    let(:org1) { StubFactory.organization(:username => "rt") }
    let(:org2) { StubFactory.organization(:username => "z-fighters") }

    context "you have at least one project on semaphore" do
      let(:project1) { StubFactory.project }
      let(:project2) { StubFactory.project }

      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/#{org1[:username]}/projects").to_return(200, [project1])
        stub_api(:get, "/orgs/#{org2[:username]}/projects").to_return(200, [project2])
      end

      it "lists all projects" do
        stdout, stderr = sem_run!("projects:list")

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
        stdout, stderr = sem_run!("projects:list")

        expect(stdout).to include("Add your first project")
      end
    end
  end

  describe "#info" do
    context "project exists on semaphore" do
      let(:project) { StubFactory.project }

      it "shows detailed information about a project" do
        stub_api(:get, "/orgs/rt/projects/?name=cli").to_return(200, [project])

        stdout, stderr = sem_run!("projects:info rt/cli")

        expect(stdout).to include(project[:id])
      end
    end

    context "project not found on semaphore" do
      it "shows project not found" do
        stub_api(:get, "/orgs/rt/projects/?name=cli").to_return(404, [])

        stdout, stderr, status = sem_run("projects:info rt/cli")

        expect(stdout).to include("Project rt/cli not found")
        expect(status).to eq(:fail)
      end
    end
  end

  describe Sem::CLI::Projects::SharedConfigs do
    let(:project) { StubFactory.project(:name => "cli") }

    describe "#list" do
      context "you have at least one shared_config attached to a project" do
        let(:shared_config1) { StubFactory.shared_config }
        let(:shared_config2) { StubFactory.shared_config }

        before do
          stub_api(:get, "/orgs/rt/projects/?name=cli").to_return(200, [project])
          stub_api(:get, "/projects/#{project[:id]}/shared_configs").to_return(200, [shared_config1, shared_config2])

          stub_api(:get, "/shared_configs/#{shared_config1[:id]}/config_files").to_return(200, [])
          stub_api(:get, "/shared_configs/#{shared_config2[:id]}/config_files").to_return(200, [])

          stub_api(:get, "/shared_configs/#{shared_config1[:id]}/env_vars").to_return(200, [])
          stub_api(:get, "/shared_configs/#{shared_config2[:id]}/env_vars").to_return(200, [])
        end

        it "lists all shared configurations on the project" do
          stdout, stderr = sem_run!("projects:shared-configs:list rt/cli")

          expect(stdout).to include(shared_config1[:id])
          expect(stdout).to include(shared_config2[:id])
        end
      end

      context "no shared_configuration attached to the project" do
        before do
          stub_api(:get, "/orgs/rt/projects/?name=cli").to_return(200, [project])
          stub_api(:get, "/projects/#{project[:id]}/shared_configs").to_return(200, [])
        end

        it "offers you to create and attach a shared configuration" do
          stdout, stderr = sem_run!("projects:shared-configs:list rt/cli")

          expect(stdout).to include("Add your first shared configuration")
        end
      end
    end

    describe "#add" do
      let(:shared_config) { StubFactory.shared_config(:name => "tokens") }

      before do
        stub_api(:get, "/orgs/rt/projects/?name=cli").to_return(200, [project])
        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
      end

      it "adds the shared configuration to the project" do
        stdout, stderr = sem_run!("projects:shared-configs:add rt/cli rt/tokens")

        expect(stdout).to include("")
      end
    end

    describe "#remove" do
      before do
        allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      end

      it "adds the shared configuration to the project" do
        expect(project).to receive(:remove_shared_config).with(shared_config)

        sem_run("projects:shared-configs:remove rt/cli rt/tokens")
      end
    end

  end

end
