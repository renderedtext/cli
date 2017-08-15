require "spec_helper"

describe Sem::CLI::SharedConfigs do

  describe "#list" do
    it "lists shared configurations" do
      stdout, stderr = sem_run("shared-configs:list")

      msg = [
        "ID                                    NAME                     CONFIG FILES  ENV VARS",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/aws-tokens  3             1",
        "37d8fdc0-4a96-4535-a4bc-601d1c7c7058  renderedtext/rubygems    1             0"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#info" do
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
    it "create a new shared configuration" do
      stdout, stderr = sem_run("shared-configs:create renderedtext/tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   renderedtext/tokens",
        "Config Files           0",
        "Environment Variables  0",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#rename" do
    it "renames a shared configuration" do
      stdout, stderr = sem_run("shared-configs:rename renderedtext/tokens renderedtext/new-tokens")

      msg = [
        "ID                     3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name                   renderedtext/new-tokens",
        "Config Files           0",
        "Environment Variables  0",
        "Created                2017-08-01 13:14:40 +0200",
        "Updated                2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

  describe "#delete" do
    it "deletes the shared configuration" do
      stdout, stderr = sem_run("shared-configs:delete renderedtext/tokens")

      expect(stdout.strip).to eq("Deleted shared configuration renderedtext/tokens")
      expect(stderr).to eq("")
    end
  end

  describe Sem::CLI::SharedConfigs::Files do

    describe "#list" do
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
      it "adds a file to the shared configuration" do
        stdout, stderr = sem_run("shared-configs:files:add renderedtext/tokens secrets.yml -f secrets.yml")

        expect(stdout.strip).to eq("Added secrets.yml to renderedtext/tokens")
        expect(stderr).to eq("")
      end
    end

    describe "#remove" do
      it "deletes a file from the shared configuration" do
        stdout, stderr = sem_run("shared-configs:files:remove renderedtext/tokens secrets.yml")

        expect(stdout.strip).to eq("Removed secrets.yml from renderedtext/tokens")
        expect(stderr).to eq("")
      end
    end

  end

  describe Sem::CLI::SharedConfigs::EnvVars do

    describe "#list" do
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
      it "adds an env var to the shared configuration" do
        stdout, stderr = sem_run("shared-configs:env-vars:add rt/tokens --name AWS_CLIENT_ID --content 3412341234123")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Added AWS_CLIENT_ID to rt/tokens")
      end
    end

    describe "#remove" do
      it "deletes an env var from the shared configuration" do
        stdout, stderr = sem_run("shared-configs:env-vars:remove renderedtext/tokens AWS_CLIENT_ID")

        expect(stdout.strip).to eq("Removed AWS_CLIENT_ID from renderedtext/tokens")
        expect(stderr).to eq("")
      end
    end

  end

end