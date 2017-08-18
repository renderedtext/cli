require "spec_helper"

RSpec.describe Sem do

  it "has a version number" do
    expect(Sem::VERSION).not_to be nil
  end

  describe ".start" do
    it "passed the arguments to the CLI client" do
      expect(Sem::CLI).to receive(:start).with(["a", "b", "c"])

      expect(Sem.start(["a", "b", "c"])).to eq(0)
    end

    it "handles the Sem::Errors::Auth::NoCredentials exception" do
      allow(Sem::CLI).to receive(:start).and_raise(Sem::Errors::Auth::NoCredentials)

      stdout, _stderr, result = collect_output { Sem.start(["a", "b", "c"]) }

      msg = [
        "[ERROR] You are not logged in.",
        "",
        "Log in with 'sem login --auth-token <token>'",
        ""
      ]

      expect(stdout).to include(msg.join("\n"))
      expect(result).to eq(1)
    end

    it "handles the Sem::Errors::Auth::InvalidCredentilsCredentials exception" do
      allow(Sem::CLI).to receive(:start).and_raise(Sem::Errors::Auth::InvalidCredentials)

      stdout, _stderr, result = collect_output { Sem.start(["a", "b", "c"]) }

      msg = [
        "[ERROR] Your credentials are invalid.",
        "",
        "Log in with 'sem login --auth-token <token>'",
        ""
      ]

      expect(stdout).to include(msg.join("\n"))
      expect(result).to eq(1)
    end

    it "handles all exceptions" do
      allow(Sem::CLI).to receive(:start) { raise "Haisenberg" }

      stdout, _stderr, result = collect_output { Sem.start(["a", "b", "c"]) }

      msg = [
        "[PANIC] Unhandled error.",
        "",
        "Well, this is emberassing. An unknown error was detected.",
        "Please report this issue to https://semaphoreci.com/support.",
        "",
        "Backtrace:"
      ]

      expect(stdout).to include(msg.join("\n"))
      expect(result).to eq(1)
    end
  end

end
