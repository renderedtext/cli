require "spec_helper"

describe Sem::Commands::Login do

  describe ".run" do
    it "displays the main help screen" do
      allow(STDIN).to receive(:gets).and_return("shiroyasha", "test1234")

      output = [
        "Username: Password: ",
        "",
        "Thanks shiroyasha!",
        "",
        "Now please go to https://semaphoreci.com/users/edit,",
        "fetch your auth token and put it in the ~/.sem/credentials file.",
        "",
        ":troll:",
        ""
      ]

      expect { Sem::Commands::Login.run([]) }.to output(output.join("\n")).to_stdout
    end
  end
end
