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
    it "rename a shared configuration" do
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

end
