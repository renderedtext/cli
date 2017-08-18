require "spec_helper"

describe Sem::CLI do

  describe "#login" do
    before { allow(Sem::Credentials).to receive(:write) }

    it "writes the credentials" do
      expect(Sem::Credentials).to receive(:write).with("123456")

      sem_run("login 123456")
    end

    it "lists organizations" do
      stdout, stderr = sem_run("login 123456")

      msg = [
        "Your credentials have been saved to #{Sem::Credentials::PATH}"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
    end
  end

end
