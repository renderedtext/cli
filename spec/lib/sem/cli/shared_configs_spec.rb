require "spec_helper"

describe Sem::CLI::SharedConfigs do

  describe "#list" do
    let(:org1) { ApiResponse.organization(:username => "rt") }
    let(:org2) { ApiResponse.organization(:username => "z-fighters") }

    context "you have at least one shared config on semaphore" do
      let(:shared_config1) { ApiResponse.shared_config }
      let(:shared_config2) { ApiResponse.shared_config }

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
        stdout, _stderr = sem_run!("shared-configs:list")

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
        stdout, _stderr = sem_run!("shared-configs:list")

        expect(stdout).to include("Create your first shared configuration")
      end
    end
  end

  describe "#info" do
    context "shared_config exists" do
      let(:shared_config) { ApiResponse.shared_config(:name => "tokens") }

      before do
        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])

        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a shared_config" do
        stdout, _stderr = sem_run!("shared-configs:info rt/tokens")

        expect(stdout).to include(shared_config[:id])
      end
    end

    context "shared_config doesn't exists" do
      before do
        stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [])
      end

      it "displays an error" do
        stdout, _stderr, status = sem_run("shared-configs:info rt/tokens")

        expect(stdout).to include("Shared Configuration rt/tokens not found.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#create" do
    context "creation succeds" do
      let(:shared_config) { ApiResponse.shared_config(:name => "tokens") }

      before do
        stub_api(:post, "/orgs/rt/shared_configs").to_return(200, shared_config)

        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a shared_config" do
        stdout, _stderr = sem_run!("shared-configs:create rt/tokens")

        expect(stdout).to include(shared_config[:id])
      end
    end

    context "creation fails" do
      before do
        stub_api(:post, "/orgs/rt/shared_configs").to_return(422, "")
      end

      it "displays an error" do
        stdout, _stderr, status = sem_run("shared-configs:create rt/tokens")

        expect(stdout).to include("Shared Configuration rt/tokens not created.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#rename" do
    let(:shared_config) { ApiResponse.shared_config(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
    end

    context "update succeds" do
      before do
        stub_api(:patch, "/shared_configs/#{shared_config[:id]}", :name => "secrets").to_return(200, shared_config)

        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a shared_config" do
        stdout, _stderr = sem_run!("shared-configs:rename rt/tokens rt/secrets")

        expect(stdout).to include(shared_config[:id])
      end
    end

    context "update fails" do
      before do
        stub_api(:patch, "/shared_configs/#{shared_config[:id]}").to_return(422, "")
      end

      it "displays an error" do
        stdout, _stderr, status = sem_run("shared-configs:rename rt/tokens rt/secrets")

        expect(stdout).to include("Shared Configuration rt/tokens not updated")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#delete" do
    let(:shared_config) { ApiResponse.shared_config(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
      stub_api(:delete, "/shared_configs/#{shared_config[:id]}").to_return(204, "")
    end

    it "shows detailed information about a shared_config" do
      stdout, _stderr = sem_run!("shared-configs:delete rt/tokens")

      expect(stdout).to include("Deleted shared configuration rt/tokens")
    end
  end

  describe Sem::CLI::SharedConfigs::Files do
    let(:shared_config) { ApiResponse.shared_config(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
    end

    describe "#list" do
      context "you have at least one file added to the shared configuration" do
        let(:file1) { ApiResponse.file(:path => "/etc/a") }
        let(:file2) { ApiResponse.file(:path => "/tmp/b") }

        before do
          stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [file1, file2])
        end

        it "lists all shared configurations on the project" do
          stdout, _stderr = sem_run("shared-configs:files:list rt/tokens")

          expect(stdout).to include(file1[:path])
          expect(stdout).to include(file2[:path])
        end
      end

      context "no files are added to the shared configuration" do
        before do
          stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [])
        end

        it "offers you to create and attach a shared configuration" do
          stdout, _stderr = sem_run!("shared-configs:files:list rt/tokens")

          expect(stdout).to include("Add your first file")
        end
      end
    end

    describe "#add" do
      let(:file) { ApiResponse.file(:path => "/etc/a") }

      before do
        stub_api(:post, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, file)
      end

      context "local file exists" do
        before { File.write("/tmp/aliases", "abc") }

        it "adds the file to the shared config" do
          stdout, _stderr = sem_run("shared-configs:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")

          expect(stdout).to include("Added /etc/aliases to rt/tokens")
        end
      end

      context "local file does not exists" do
        before { FileUtils.rm_f("/tmp/aliases") }

        it "aborts and displays an error" do
          _stdout, stderr, status = sem_run("shared-configs:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")

          expect(status).to be(:system_error)
          expect(stderr.strip).to eq("File /tmp/aliases not found")
        end
      end
    end

    describe "#remove" do
      let(:file) { ApiResponse.file(:path => "/etc/a") }

      before do
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/config_files").to_return(200, [file])
        stub_api(:delete, "/config_files/#{file[:id]}").to_return(204, "")
      end

      it "removes the shared configuration to the project" do
        stdout, _stderr = sem_run!("shared-configs:files:remove rt/tokens --path /etc/a")

        expect(stdout).to include("Removed /etc/a from rt/tokens")
      end
    end
  end

  describe Sem::CLI::SharedConfigs::EnvVars do
    let(:shared_config) { ApiResponse.shared_config(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/shared_configs").to_return(200, [shared_config])
    end

    describe "#list" do
      context "you have at least one env_var added to the shared configuration" do
        let(:env_var1) { ApiResponse.env_var }
        let(:env_var2) { ApiResponse.env_var }

        before do
          stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [env_var1, env_var2])
        end

        it "lists all env vars in a shared_config" do
          stdout, _stderr = sem_run("shared-configs:env-vars:list rt/tokens")

          expect(stdout).to include(env_var1[:name])
          expect(stdout).to include(env_var2[:name])
        end
      end

      context "no files are added to the shared configuration" do
        before do
          stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [])
        end

        it "offers you to create and attach an env var" do
          stdout, _stderr = sem_run!("shared-configs:env-vars:list rt/tokens")

          expect(stdout).to include("Add your first environment variable")
        end
      end
    end

    describe "#add" do
      let(:env_var) { ApiResponse.env_var }

      before do
        stub_api(:post, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, env_var)
      end

      it "adds the env var to the shared config" do
        stdout, _stderr = sem_run!("shared-configs:env-vars:add rt/tokens --name SECRET --content abc")

        expect(stdout).to include("Added SECRET to rt/tokens")
      end
    end

    describe "#remove" do
      let(:env_var) { ApiResponse.env_var(:name => "TOKEN") }

      before do
        stub_api(:get, "/shared_configs/#{shared_config[:id]}/env_vars").to_return(200, [env_var])
        stub_api(:delete, "/env_vars/#{env_var[:id]}").to_return(204, "")
      end

      it "removes the env vars from the shared configurations" do
        stdout, _stderr = sem_run!("shared-configs:env-vars:remove rt/tokens --name TOKEN")

        expect(stdout).to include("Removed TOKEN from rt/tokens")
      end
    end

  end
end
