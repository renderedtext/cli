require "spec_helper"

RSpec.describe Sem do
  it "has a version number" do
    expect(Sem::VERSION).not_to be nil
  end

  describe ".run" do
    context "first argument is 'help'" do
      it "runs the help command" do
        params = ["help", "arg1", "arg2"]

        expect(Sem::Commands::Help).to receive(:run).with(["arg1", "arg2"])

        Sem.run(params)
      end
    end
  end

end
