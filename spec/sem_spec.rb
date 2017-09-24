require "spec_helper"

RSpec.describe Sem do

  it "has a version number" do
    expect(Sem::VERSION).not_to be nil
  end

  describe ".start" do
    describe "--trace argument" do
      it "sets the output to trace level" do
        expect { Sem.start(["--trace"]) }
          .to change { Sem.log_level }
          .from(Sem::LOG_LEVEL_ERROR)
          .to(Sem::LOG_LEVEL_TRACE)
      end
    end

    it "passed the arguments to the CLI client" do
      expect(Sem::CLI).to receive(:start).with(["a", "b", "c"])

      expect(Sem.start(["a", "b", "c"])).to eq(0)
    end

    it "handles the Sem::Errors::Auth::NoCredentials exception" do
      allow(Sem::CLI).to receive(:start).and_raise(Sem::Errors::Auth::NoCredentials)

      stdout, _stderr, result = IOStub.collect_output { Sem.start(["a", "b", "c"]) }

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

      stdout, _stderr, result = IOStub.collect_output { Sem.start(["a", "b", "c"]) }

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

      stdout, _stderr, result = IOStub.collect_output { Sem.start(["a", "b", "c"]) }

      msg = [
        "[PANIC] Unhandled error.",
        "",
        "Well, this is embarrassing. An unknown error was detected.",
        "",
        "Exception:",
        "Haisenberg",
        "",
        "Backtrace:"
      ]

      expect(stdout).to include(msg.join("\n"))
      expect(stdout).to include("Please report this issue to https://semaphoreci.com/support.")
      expect(result).to eq(1)
    end
  end

end
