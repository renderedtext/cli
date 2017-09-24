require "spec_helper"

describe Sem::Views::Teams do
  let(:team1) { StubFactory.team("rt", :name => "devs") }
  let(:team2) { StubFactory.team("rt", :name => "admins") }

  let(:user1) { StubFactory.user }
  let(:user2) { StubFactory.user(:username => "star-lord") }

  before do
    allow(team1).to receive(:users).and_return([user1, user2])
    allow(team2).to receive(:users).and_return([])
  end

  describe ".list" do
    it "displays a table of teams" do
      msg = [
        "ID                                    NAME       PERMISSION  MEMBERS",
        "1bc7ed43-ac8a-487e-b488-c38bc757a034  rt/devs    write       2 members",
        "1bc7ed43-ac8a-487e-b488-c38bc757a034  rt/admins  write       0 members",
        ""
      ]

      expect { Sem::Views::Teams.list([team1, team2]) }.to output(msg.join("\n")).to_stdout
    end
  end

  describe ".info" do
    it "prints the team in table format" do
      msg = [
        "ID          1bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        rt/devs",
        "Permission  write",
        "Members     2",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200",
        ""
      ]

      expect { Sem::Views::Teams.info(team1) }.to output(msg.join("\n")).to_stdout
    end
  end

end
