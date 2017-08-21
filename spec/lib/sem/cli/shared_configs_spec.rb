require "spec_helper"

describe Sem::CLI::SharedConfigs do

  let(:shared_config) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "renderedtext/aws-tokens",
      :config_files => 3,
      :env_vars => 1,
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    let(:another_shared_config) do
      {
        :id => "37d8fdc0-4a96-4535-a4bc-601d1c7c7058",
        :name => "renderedtext/rubygems",
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
      stdout, stderr = sem_run("shared-configs:list")

      msg = [
        "ID                                    NAME                     CONFIG FILES  ENV VARS",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/aws-tokens             3         1",
        "37d8fdc0-4a96-4535-a4bc-601d1c7c7058  renderedtext/rubygems               1         0"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#info" do
    before { allow(Sem::API::SharedConfigs).to receive(:info).and_return(shared_config) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:info).with("renderedtext", "aws-tokens")

      sem_run("shared-configs:info renderedtext/aws-tokens")
    end

    it "shows information about a shared configuration" do
      stdout, stderr = sem_run("shared-configs:info renderedtext/aws-tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   renderedtext/aws-tokens",
        "Config Files           3",
        "Environment Variables  1",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#create" do
    before { allow(Sem::API::SharedConfigs).to receive(:create).and_return(shared_config) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:create).with("renderedtext", :name => "aws-tokens")

      sem_run("shared-configs:create renderedtext/aws-tokens")
    end

    it "create a new shared configuration" do
      stdout, stderr = sem_run("shared-configs:create renderedtext/aws-tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   renderedtext/aws-tokens",
        "Config Files           3",
        "Environment Variables  1",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#rename" do
    before { allow(Sem::API::SharedConfigs).to receive(:update).and_return(shared_config) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:update).with("renderedtext", "tokens", :name => "aws-tokens")

      sem_run("shared-configs:rename renderedtext/tokens renderedtext/aws-tokens")
    end

    it "renames a shared configuration" do
      stdout, stderr = sem_run("shared-configs:rename renderedtext/tokens renderedtext/aws-tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   renderedtext/aws-tokens",
        "Config Files           3",
        "Environment Variables  1",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#delete" do
    before { allow(Sem::API::SharedConfigs).to receive(:delete) }

    it "calls the API" do
      expect(Sem::API::SharedConfigs).to receive(:delete).with("renderedtext", "tokens")

      sem_run("shared-configs:delete renderedtext/tokens")
    end

    it "deletes the shared configuration" do
      stdout, stderr = sem_run("shared-configs:delete renderedtext/tokens")

      expect(stdout.strip).to eq("Deleted shared configuration renderedtext/tokens")
      expect(stderr).to eq("")
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
        expect(Sem::API::SharedConfigs).to receive(:list_files).with("renderedtext", "tokens")

        sem_run("shared-configs:files:list renderedtext/tokens")
      end

      it "lists files in a shared_configuration" do
        stdout, stderr = sem_run("shared-configs:files:list renderedtext/tokens")

        msg = [
          "ID                                    NAME         ENCRYPTED?",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  secrets.txt  true",
          "37d8fdc0-4a96-4535-a4bc-601d1c7c7058  config.yml   true"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
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

        sem_run("shared-configs:files:add renderedtext/tokens secrets.yml -f secrets.yml")
      end

      it "calls the projects API" do
        expect(Sem::API::Files).to receive(:add_to_shared_config).with("renderedtext",
                                                                       "tokens",
                                                                       :path => "secrets.yml",
                                                                       :content => content)

        sem_run("shared-configs:files:add renderedtext/tokens secrets.yml -f secrets.yml")
      end

      it "adds a file to the shared configuration" do
        stdout, stderr = sem_run("shared-configs:files:add renderedtext/tokens secrets.yml -f secrets.yml")

        expect(stdout.strip).to eq("Added secrets.yml to renderedtext/tokens")
        expect(stderr).to eq("")
      end
    end

    describe "#remove" do
      before { allow(Sem::API::Files).to receive(:remove_from_shared_config) }

      it "calls the projects API" do
        expect(Sem::API::Files).to receive(:remove_from_shared_config).with("renderedtext", "tokens", "secrets.yml")

        sem_run("shared-configs:files:remove renderedtext/tokens secrets.yml")
      end

      it "deletes a file from the shared configuration" do
        stdout, stderr = sem_run("shared-configs:files:remove renderedtext/tokens secrets.yml")

        expect(stdout.strip).to eq("Removed secrets.yml from renderedtext/tokens")
        expect(stderr).to eq("")
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
        expect(Sem::API::SharedConfigs).to receive(:list_env_vars).with("renderedtext", "tokens")

        sem_run("shared-configs:env-vars:list renderedtext/tokens")
      end

      it "lists env vars in a shared_configuration" do
        stdout, stderr = sem_run("shared-configs:env-vars:list renderedtext/tokens")

        msg = [
          "ID                                    NAME           ENCRYPTED?  CONTENT",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  AWS_CLIENT_ID  true        -",
          "37d8fdc0-4a96-4535-a4bc-601d1c7c7058  EMAIL          false       admin@semaphoreci.com"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
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
        stdout, stderr = sem_run("shared-configs:env-vars:add rt/tokens --name AWS_CLIENT_ID --content 3412341234123")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Added AWS_CLIENT_ID to rt/tokens")
      end
    end

    describe "#remove" do
      before { allow(Sem::API::EnvVars).to receive(:remove_from_shared_config) }

      it "calls the projects API" do
        expect(Sem::API::EnvVars).to receive(:remove_from_shared_config).with("renderedtext", "tokens", "AWS_CLIENT_ID")

        sem_run("shared-configs:env-vars:remove renderedtext/tokens AWS_CLIENT_ID")
      end

      it "deletes an env var from the shared configuration" do
        stdout, stderr = sem_run("shared-configs:env-vars:remove renderedtext/tokens AWS_CLIENT_ID")

        expect(stdout.strip).to eq("Removed AWS_CLIENT_ID from renderedtext/tokens")
        expect(stderr).to eq("")
      end
    end

  end

end
