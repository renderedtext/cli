require "spec_helper"

describe Sem::CLI::SharedConfigs do

  let(:shared_config) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :org => "rt",
      :name => "aws-tokens",
      :config_files => 3,
      :env_vars => 1,
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    context "when the user has multiple shared configs" do
      let(:another_shared_config) do
        {
          :id => "37d8fdc0-4a96-4535-a4bc-601d1c7c7058",
          :org => "rt",
          :name => "rubygems",
          :config_files => 1,
          :env_vars => 0
        }
      end

      before { allow(Sem::API::SharedConfigs).to receive(:list).and_return([shared_config, another_shared_config]) }

      it "calls the API" do
        expect(Sem::API::SharedConfigs).to receive(:list)

        sem_run("shared-configs:list")
      end

      it "lists shared configurations" do
        stdout, stderr, status = sem_run("shared-configs:list")

        msg = [
          "ID                                    NAME           CONFIG FILES  ENV VARS",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  rt/aws-tokens             3         1",
          "37d8fdc0-4a96-4535-a4bc-601d1c7c7058  rt/rubygems               1         0"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

    context "when the user has no shared configs" do
      before { allow(Sem::API::SharedConfigs).to receive(:list).and_return([]) }

      it "offers to create your first shared config" do
        stdout, stderr, status = sem_run("shared-configs:list")

        msg = [
          "You don't have any shared configurations on Semaphore.",
          "",
          "Create your first shared configuration:",
          "",
          "  sem shared-config:create ORG_NAME/SHARED_CONFIG",
          "",
          ""
        ]

        expect(stdout).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end
  end

  describe "#info" do
    before { allow(Sem::API::SharedConfigs).to receive(:info).and_return(shared_config) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:info).with("rt", "aws-tokens")

      sem_run("shared-configs:info rt/aws-tokens")
    end

    it "shows information about a shared configuration" do
      stdout, stderr, status = sem_run("shared-configs:info rt/aws-tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   rt/aws-tokens",
        "Config Files           3",
        "Environment Variables  1",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
      expect(status).to eq(:ok)
    end
  end

  describe "#create" do
    before { allow(Sem::API::SharedConfigs).to receive(:create).and_return(shared_config) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:create).with("rt", :name => "aws-tokens")

      sem_run("shared-configs:create rt/aws-tokens")
    end

    it "create a new shared configuration" do
      stdout, stderr, status = sem_run("shared-configs:create rt/aws-tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   rt/aws-tokens",
        "Config Files           3",
        "Environment Variables  1",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
      expect(status).to eq(:ok)
    end
  end

  describe "#rename" do
    before { allow(Sem::API::SharedConfigs).to receive(:update).and_return(shared_config) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:update).with("rt", "tokens", :name => "aws-tokens")

      sem_run("shared-configs:rename rt/tokens rt/aws-tokens")
    end

    context "org names are not matching" do
      it "raises an exception" do
        stdout, stderr, status = sem_run("shared-configs:rename rt/tokens org/aws-tokens")

        msg = [
          "[ERROR] Organization names not matching.",
          "",
          "Old shared configuration name \"rt/tokens\" and new shared configuration name \"org/aws-tokens\"" \
          " are not in the same organization."
        ]

        expect(stderr.strip).to eq(msg.join("\n"))
        expect(stdout.strip).to eq("")
        expect(status).to eq(:system_error)
      end
    end

    it "renames a shared configuration" do
      stdout, stderr, status = sem_run("shared-configs:rename rt/tokens rt/aws-tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   rt/aws-tokens",
        "Config Files           3",
        "Environment Variables  1",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
      expect(status).to eq(:ok)
    end
  end

  describe "#delete" do
    before { allow(Sem::API::SharedConfigs).to receive(:delete) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:delete).with("rt", "tokens")

      sem_run("shared-configs:delete rt/tokens")
    end

    it "deletes the shared configuration" do
      stdout, stderr, status = sem_run("shared-configs:delete rt/tokens")

      expect(stdout.strip).to eq("Deleted shared configuration rt/tokens")
      expect(stderr).to eq("")
      expect(status).to eq(:ok)
    end
  end

  describe Sem::CLI::SharedConfigs::Files do

    describe "#list" do
      let(:file_0) do
        {
          :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
          :name => "secrets.txt",
          :encrypted? => true
        }
      end

      let(:file_1) do
        {
          :id => "37d8fdc0-4a96-4535-a4bc-601d1c7c7058",
          :name => "config.yml",
          :encrypted? => true
        }
      end

      before { allow(Sem::API::SharedConfigs).to receive(:list_files).and_return([file_0, file_1]) }

      it "calls the configs API" do
        expect(Sem::API::SharedConfigs).to receive(:list_files).with("rt", "tokens")

        sem_run("shared-configs:files:list rt/tokens")
      end

      it "lists files in a shared_configuration" do
        stdout, stderr, status = sem_run("shared-configs:files:list rt/tokens")

        msg = [
          "ID                                    NAME         ENCRYPTED?",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  secrets.txt  true",
          "37d8fdc0-4a96-4535-a4bc-601d1c7c7058  config.yml   true"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

    describe "#add" do
      let(:content) { "content" }

      before do
        allow(File).to receive(:read).and_return(content)
        allow(Sem::API::Files).to receive(:add_to_shared_config)
      end

      it "reads the file" do
        expect(File).to receive(:read).with("secrets.yml")

        sem_run("shared-configs:files:add rt/tokens secrets.yml -f secrets.yml")
      end

      it "calls the projects API" do
        expect(Sem::API::Files).to receive(:add_to_shared_config).with("rt",
                                                                       "tokens",
                                                                       :path => "secrets.yml",
                                                                       :content => content)

        sem_run("shared-configs:files:add rt/tokens secrets.yml -f secrets.yml")
      end

      it "adds a file to the shared configuration" do
        stdout, stderr, status = sem_run("shared-configs:files:add rt/tokens secrets.yml -f secrets.yml")

        expect(stdout.strip).to eq("Added secrets.yml to rt/tokens")
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

    describe "#remove" do
      before { allow(Sem::API::Files).to receive(:remove_from_shared_config) }

      it "calls the projects API" do
        expect(Sem::API::Files).to receive(:remove_from_shared_config).with("rt", "tokens", "secrets.yml")

        sem_run("shared-configs:files:remove rt/tokens secrets.yml")
      end

      it "deletes a file from the shared configuration" do
        stdout, stderr, status = sem_run("shared-configs:files:remove rt/tokens secrets.yml")

        expect(stdout.strip).to eq("Removed secrets.yml from rt/tokens")
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

  end

  describe Sem::CLI::SharedConfigs::EnvVars do

    describe "#list" do
      let(:env_var_0) do
        {
          :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
          :name => "AWS_CLIENT_ID",
          :encrypted? => true,
          :content => "-"
        }
      end

      let(:env_var_1) do
        {
          :id => "37d8fdc0-4a96-4535-a4bc-601d1c7c7058",
          :name => "EMAIL",
          :encrypted? => false,
          :content => "admin@semaphoreci.com"
        }
      end

      before { allow(Sem::API::SharedConfigs).to receive(:list_env_vars).and_return([env_var_0, env_var_1]) }

      it "calls the configs API" do
        expect(Sem::API::SharedConfigs).to receive(:list_env_vars).with("rt", "tokens")

        sem_run("shared-configs:env-vars:list rt/tokens")
      end

      it "lists env vars in a shared_configuration" do
        stdout, stderr, status = sem_run("shared-configs:env-vars:list rt/tokens")

        msg = [
          "ID                                    NAME           ENCRYPTED?  CONTENT",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  AWS_CLIENT_ID  true        -",
          "37d8fdc0-4a96-4535-a4bc-601d1c7c7058  EMAIL          false       admin@semaphoreci.com"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

    describe "#add" do
      before { allow(Sem::API::EnvVars).to receive(:add_to_shared_config) }

      it "calls the projects API" do
        expect(Sem::API::EnvVars).to receive(:add_to_shared_config).with("rt",
                                                                         "tokens",
                                                                         :name => "AWS_CLIENT_ID",
                                                                         :content => "3412341234123")

        sem_run("shared-configs:env-vars:add rt/tokens --name AWS_CLIENT_ID --content 3412341234123")
      end

      it "adds an env var to the shared configuration" do
        stdout, stderr, status =
          sem_run("shared-configs:env-vars:add rt/tokens --name AWS_CLIENT_ID --content 3412341234123")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Added AWS_CLIENT_ID to rt/tokens")
        expect(status).to eq(:ok)
      end
    end

    describe "#remove" do
      before { allow(Sem::API::EnvVars).to receive(:remove_from_shared_config) }

      it "calls the projects API" do
        expect(Sem::API::EnvVars).to receive(:remove_from_shared_config).with("rt", "tokens", "AWS_CLIENT_ID")

        sem_run("shared-configs:env-vars:remove rt/tokens AWS_CLIENT_ID")
      end

      it "deletes an env var from the shared configuration" do
        stdout, stderr, status = sem_run("shared-configs:env-vars:remove rt/tokens AWS_CLIENT_ID")

        expect(stdout.strip).to eq("Removed AWS_CLIENT_ID from rt/tokens")
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

  end

end
