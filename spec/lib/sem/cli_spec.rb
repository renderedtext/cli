require "spec_helper"

describe Sem::CLI do

  describe "#login" do
    before { allow(Sem::Credentials).to receive(:write) }

    context "when the credentials are valid" do
      before { allow(Sem::Credentials).to receive(:valid?).and_return(true) }

      it "writes the credentials" do
        expect(Sem::Credentials).to receive(:write).with("123456")

        sem_run("login --auth_token 123456")
      end

      it "displays a success message" do
        stdout, stderr = sem_run("login --auth_token 123456")

        msg = [
          "Your credentials have been saved to #{Sem::Credentials::PATH}."
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
      end
    end

    context "not valid auth token" do
      before { allow(Sem::Credentials).to receive(:valid?).and_return(false) }

      it "writes an error to the output" do
        stdout, stderr = sem_run("login --auth_token 123456")

        msg = [
          "[ERROR] Token is invalid!"
        ]

        expect(stderr.strip).to eq(msg.join("\n"))
      end

      it "does not save the auth token" do
        expect(Sem::Credentials).to_not receive(:write).with("123456")

        sem_run("login --auth_token 123456")
      end
    end
  end

end
