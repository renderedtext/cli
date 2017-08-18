require "spec_helper"

RSpec.describe Sem do

  it "has a version number" do
    expect(Sem::VERSION).not_to be nil
  end

  describe ".start" do
    it "passed the arguments to the CLI client" do
      expect(Sem::CLI).to receive(:start).with(["a", "b", "c"])

      Sem.start(["a", "b", "c"])
    end

    it "handles the Sem::Errors::Auth::NoCredentials exception" do
      allow(Sem::CLI).to receive(:start).and_raise(Sem::Errors::Auth::NoCredentials)

      msg = [
        "[ERROR] You are not logged in.",
        "",
        "Log in with 'sem login --auth-token <token>'",
        ""
      ]

      expect { Sem.start(["a", "b", "c"]) }.to output(msg.join("\n")).to_stdout
    end
  end

end
