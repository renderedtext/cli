require "spec_helper"

describe Sem::Views::Users do
  let(:user1) { StubFactory.user(:username => "yoda") }
  let(:user2) { StubFactory.user(:username => "star-lord") }

  describe ".list" do
    it "prints users in a table" do
      msg = [
        "NAME",
        "yoda",
        "star-lord",
        ""
      ]

      expect { Sem::Views::Users.list([user1, user2]) }.to output(msg.join("\n")).to_stdout
    end
  end
end
