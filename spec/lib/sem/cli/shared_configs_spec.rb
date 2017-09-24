require "spec_helper"

describe Sem::CLI::SharedConfigs do

  describe "#list" do
    let(:org1) { StubFactory.organization(:username => "rt") }
    let(:org2) { StubFactory.organization(:username => "z-fighters") }

    context "you have at least one shared config on semaphore" do
      let(:shared_config1) { StubFactory.shared_config }
      let(:shared_config2) { StubFactory.shared_config }

      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config1])
        stub_api(:get, "/orgs/z-fighters/shared_configs").to_return(200, [shared_config2])

        stub_api(:get, "/shared_configs/#{shared_config1[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config1[:id]}/env_vars").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config2[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config2[:id]}/env_vars").to_return(200, [])
      end

      it "lists all shared_configs" do
        stdout, stderr = sem_run!("shared-configs:list")

        expect(stdout).to include(shared_config1[:id])
        expect(stdout).to include(shared_config2[:id])
      end
    end

    context "no shared_config on semaphore" do
      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [])
        stub_api(:get, "/orgs/z-fighters/shared_configs").to_return(200, [])
      end

      it "offers you to set up a shared_config on semaphore" do
        stdout, stderr = sem_run!("shared-configs:list")

        expect(stdout).to include("Create your first shared configuration")
      end
    end
  end

  describe "#info" do
    context "shared_config exists" do
      let(:shared_config) { StubFactory.shared_config(:name => "tokens") }

      before do
        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])

        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a shared_config" do
        stdout, stderr = sem_run!("shared-configs:info rt/tokens")

        expect(stdout).to include(shared_config[:id])
      end
    end

    context "shared_config doesn't exists" do
      before do
        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [])
      end

      it "displays an error" do
        stdout, stderr, status = sem_run("shared-configs:info rt/tokens")

        expect(stdout).to include("Shared Configuration rt/tokens not found.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#create" do
    context "creation succeds" do
      let(:shared_config) { StubFactory.shared_config(:name => "tokens") }

      before do
        stub_api(:post, "/orgs/rt/shared_configs").to_return(200, shared_config)

        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a shared_config" do
        stdout, stderr = sem_run!("shared-configs:create rt/tokens")

        expect(stdout).to include(shared_config[:id])
      end
    end

    context "creation fails" do
      before do
        stub_api(:post, "/orgs/rt/shared_configs").to_return(422, "")
      end

      it "displays an error" do
        stdout, stderr, status = sem_run("shared-configs:create rt/tokens")

        expect(stdout).to include("Shared Configuration rt/tokens not created.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#rename" do
    let(:shared_config) { StubFactory.shared_config(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
    end

    context "update succeds" do
      before do
        stub_api(:patch, "/shared_configs/#{shared_config[:id]}").to_return(200, shared_config)

        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a shared_config" do
        stdout, stderr = sem_run!("shared-configs:rename rt/tokens rt/secrets")

        expect(stdout).to include(shared_config[:id])
      end
    end

    context "update fails" do
      before do
        stub_api(:patch, "/shared_configs/#{shared_config[:id]}").to_return(422, "")
      end

      it "displays an error" do
        stdout, stderr, status = sem_run("shared-configs:rename rt/tokens rt/secrets")

        expect(stdout).to include("Shared Configuration rt/tokens not updated")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#delete" do
    let(:shared_config) { StubFactory.shared_config(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
      stub_api(:delete, "/shared_configs/#{shared_config[:id]}").to_return(204, "")
    end

    it "shows detailed information about a shared_config" do
      stdout, stderr = sem_run!("shared-configs:delete rt/tokens")

      expect(stdout).to include("Deleted shared configuration rt/tokens")
    end
  end

  describe Sem::CLI::SharedConfigs::Files do
    let(:shared_config) { StubFactory.shared_config(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
    end

    describe "#list" do
      context "you have at least one file added to the shared configuration" do
        let(:file1) { StubFactory.file(:path => "/etc/a") }
        let(:file2) { StubFactory.file(:path => "/tmp/b") }

        before do
          stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [file1, file2])
        end

        it "lists all shared configurations on the project" do
          stdout, stderr = sem_run("shared-configs:files:list rt/tokens")

          expect(stdout).to include(file1[:path])
          expect(stdout).to include(file2[:path])
        end
      end

      context "no files are added to the shared configuration" do
        before do
          stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        end

        it "offers you to create and attach a shared configuration" do
          stdout, stderr = sem_run!("shared-configs:files:list rt/tokens")

          expect(stdout).to include("Add your first file")
        end
      end
    end

    describe "#add" do
      let(:file) { StubFactory.file(:path => "/etc/a") }

      before do
        stub_api(:post, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, file)
      end

      context "local file exists" do
        before { File.write("/tmp/aliases", "abc") }

        it "adds the file to the shared config" do
          stdout, stderr = sem_run("shared-configs:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")

          expect(stdout).to include("Added /etc/aliases to rt/tokens")
        end
      end

      context "local file does not exists" do
        before { FileUtils.rm_f("/tmp/aliases") }

        it "aborts and displays an error" do
          stdout, stderr, status = sem_run("shared-configs:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")

          expect(status).to be(:system_error)
          expect(stderr.strip).to eq("File /tmp/aliases not found")
        end
      end
    end

    describe "#remove" do
      let(:file) { StubFactory.file(:path => "/etc/a") }

      before do
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [file])
        stub_api(:delete, "/config_files/#{file[:id]}").to_return(204, "")
      end

      it "removes the shared configuration to the project" do
        stdout, stderr = sem_run!("shared-configs:files:remove rt/tokens --path /etc/a")

        expect(stdout).to include("Removed /etc/a from rt/tokens")
      end
    end
  end

  describe Sem::CLI::SharedConfigs::EnvVars do
    let(:shared_config) { StubFactory.shared_config }

    before { allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config) }

    describe "#list" do
      context "you have at least one env_var added to the shared configuration" do
        let(:env_vars) { [StubFactory.env_var, StubFactory.env_var] }

        before { allow(shared_config).to receive(:env_vars).and_return(env_vars) }

        it "lists all env vars in a shared_config" do
          expect(Sem::Views::EnvVars).to receive(:list).with(env_vars).and_call_original

          sem_run("shared-configs:env-vars:list rt/tokens")
        end
      end

      context "no files are added to the shared configuration" do
        before { allow(shared_config).to receive(:env_vars).and_return([]) }

        it "offers you to create and attach an env var" do
          expect(Sem::Views::SharedConfigs).to receive(:add_first_env_var).with(shared_config)

          sem_run("shared-configs:env-vars:list rt/tokens")
        end
      end
    end

    describe "#add" do
      before do
        allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      end

      it "adds the env var to the shared config" do
        expect(shared_config).to receive(:add_env_var).with(:name => "SECRET", :content => "abc")

        sem_run("shared-configs:env-vars:add rt/tokens --name SECRET --content abc")
      end
    end

    describe "#remove" do
      before do
        allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      end

      it "removes the env vars from the shared configurations" do
        expect(shared_config).to receive(:remove_env_var).with("SECRET")

        sem_run("shared-configs:env-vars:remove rt/tokens --name SECRET")
      end
    end

  end
end
