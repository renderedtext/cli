require "spec_helper"

describe Sem::UI do

  describe ".strong" do
    it "sets the color to green" do
      expect(Sem::UI.strong("test")).to eq("\e[31m;test\e[0m")
    end
  end

  describe ".info" do
    it "prints a message to the console" do
      expect { Sem::UI.info("test") }.to output("test\n").to_stdout
    end
  end

  describe ".list" do
    it "prints a list to the console" do
      list = [
        "projects",
        "teams",
        "orgs"
      ]

      expect { Sem::UI.list(list) }.to output("  projects\n  teams\n  orgs\n").to_stdout
    end
  end

end
