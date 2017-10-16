require "spec_helper"

RSpec.describe Sem do

  it "has a version number" do
    expect(Sem::VERSION).not_to be nil
  end

  describe ".start" do
    describe "--trace argument" do
      it "sets the output to trace level" do
        expect { Sem.start(["--trace"]) }.to change { Sem.trace? }.from(false).to(true)
      end
    end

    it "passed the arguments to the CLI client" do
      expect(Sem::CLI).to receive(:start).with(["teams:info", "a", "b", "c"])

      sem_run!("teams:info a b c")
    end

    it "handles the Sem::Errors::Auth::NoCredentials exception" do
      allow(Sem::CLI).to receive(:start).and_raise(Sem::Errors::Auth::NoCredentials)

      _stdout, stderr, status = sem_run("orgs:list")

      msg = [
        "[ERROR] You are not logged in.",
        "",
        "Log in with 'sem login --auth-token <token>'",
        ""
      ]

      expect(stderr).to include(msg.join("\n"))
      expect(status).to eq(:fail)
    end

    it "handles the Sem::Errors::Auth::InvalidCredentilsCredentials exception" do
      allow(Sem::CLI).to receive(:start).and_raise(Sem::Errors::Auth::InvalidCredentials)

      _stdout, stderr, status = sem_run("orgs:list")

      msg = [
        "[ERROR] Your credentials are invalid.",
        "",
        "Log in with 'sem login --auth-token <token>'",
        ""
      ]

      expect(stderr).to include(msg.join("\n"))
      expect(status).to eq(:fail)
    end

    it "handles http 500 from api" do
      stub_api(:get, "/orgs").to_return(500, :message => "Server errror.")

      _stdout, stderr, status = sem_run("orgs:list")

      msg = [
        "[ERROR] Semaphore API returned status 500.",
        "",
        "Server errror.",
        "",
        "Please report this issue to https://semaphoreci.com/support.",
        ""
      ]

      expect(stderr).to eq(msg.join("\n"))
      expect(status).to eq(:fail)
    end

    it "handles authorization exceptions" do
      stub_api(:get, "/orgs").to_return(401, "message" => "Invalid Authenticaion Token")

      _stdout, stderr, status = sem_run("orgs:list")

      msg = [
        "[ERROR] Invalid Authenticaion Token. Check if your credentials are valid.",
        ""
      ]

      expect(stderr).to eq(msg.join("\n"))
      expect(status).to eq(:fail)
    end

    it "handles all exceptions" do
      allow(Sem::CLI).to receive(:start) { raise "Haisenberg" }

      _stdout, stderr, status = sem_run("orgs:list")

      msg = [
        "[PANIC] Unhandled error.",
        "",
        "Well, this is embarrassing. An unknown error was detected.",
        "",
        "RuntimeError: Haisenberg",
        "",
        "Backtrace:"
      ]

      expect(stderr).to include(msg.join("\n"))
      expect(stderr).to include("Please report this issue to https://semaphoreci.com/support.")
      expect(status).to eq(:fail)
    end
  end

end
