require "spec_helper"

describe Sem::CLI::SharedConfigs do

  let(:shared_config) { StubFactory.shared_config }

  describe "#list" do
    context "you have at least one shared config on semaphore" do
      let(:another_shared_config) { StubFactory.shared_config}
      let(:shared_configs) { [shared_config, another_shared_config] }

      before { allow(Sem::API::SharedConfig).to receive(:all).and_return(shared_configs) }

      it "lists all shared_configs" do
        expect(Sem::Views::SharedConfigs).to receive(:list).with(shared_configs)

        sem_run("shared-configs:list")
      end
    end

    context "no shared_config on semaphore" do
      before do
        allow(Sem::API::SharedConfig).to receive(:all).and_return([])
      end

      it "offers you to set up a shared_config on semaphore" do
        expect(Sem::Views::SharedConfigs).to receive(:setup_first_shared_config)

        sem_run("shared-configs:list")
      end
    end
  end

  describe "#info" do
    before { allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config) }

    it "shows detailed information about a shared_config" do
      expect(Sem::Views::SharedConfigs).to receive(:info).with(shared_config)

      sem_run("shared-configs:info rt/tokens")
    end
  end

  describe "#create" do
    before { allow(Sem::API::SharedConfig).to receive(:create!).with("rt/tokens").and_return(shared_config) }

    it "shows detailed information about a shared_config" do
      expect(Sem::Views::SharedConfigs).to receive(:info).with(shared_config)

      sem_run("shared-configs:create rt/tokens")
    end
  end

  describe "#rename" do
    before do
      allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      allow(shared_config).to receive(:update!).with(:name => "rt/secrets").and_return(shared_config)
    end

    it "shows detailed information about a shared_config" do
      expect(Sem::Views::SharedConfigs).to receive(:info).with(shared_config)

      sem_run("shared-configs:rename rt/tokens rt/secrets")
    end
  end

  describe "#delete" do
    before do
      allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
    end

    it "shows detailed information about a shared_config" do
      expect(shared_config).to receive(:delete!)

      sem_run("shared-configs:delete rt/tokens")
    end
  end

  describe Sem::CLI::SharedConfigs::Files do
    let(:shared_config) { StubFactory.shared_config }

    before { allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config) }

    describe "#list" do
      context "you have at least one file added to the shared configuration" do
        let(:files) { [StubFactory.file, StubFactory.file] }

        before { allow(shared_config).to receive(:files).and_return(files) }

        it "lists all shared configurations on the project" do
          expect(Sem::Views::Files).to receive(:list).with(files).and_call_original

          sem_run("shared-configs:files:list rt/tokens")
        end
      end

      context "no files are added to the shared configuration" do
        before { allow(shared_config).to receive(:files).and_return([]) }

        it "offers you to create and attach a shared configuration" do
          expect(Sem::Views::SharedConfigs).to receive(:add_first_file).with(shared_config).and_call_original

          sem_run("shared-configs:files:list rt/tokens")
        end
      end
    end

    describe "#add" do
      before do
        allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      end

      context "local file exists" do
        before { File.write("/tmp/aliases", "abc") }

        it "adds the file to the shared config" do
          expect(shared_config).to receive(:add_config_file).with(:path => "/etc/aliases", :content => "abc")

          sem_run("shared-configs:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")
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
      before do
        allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      end

      it "removes the shared configuration to the project" do
        expect(shared_config).to receive(:remove_file).with("/etc/aliases")

        sem_run("shared-configs:files:remove rt/tokens --path /etc/aliases")
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
