require "spec_helper"

describe Sem::Views::Projects do
  let(:project1) { StubFactory.project("rt", :name => "cli") }
  let(:project2) { StubFactory.project("rt", :name => "api") }

  describe ".list" do
    it "displays a table of projects" do
      msg = [
        "ID                                    NAME",
        "99c7ed43-ac8a-487e-b488-c38bc757a034  rt/cli",
        "99c7ed43-ac8a-487e-b488-c38bc757a034  rt/api",
        ""
      ]

      expect { Sem::Views::Projects.list([project1, project2]) }.to output(msg.join("\n")).to_stdout
    end
  end

  describe ".info" do
    it "prints the team in table format" do
      msg = [
        "ID       99c7ed43-ac8a-487e-b488-c38bc757a034",
        "Name     rt/cli",
        "Created  2017-08-01 13:14:40 +0200",
        "Updated  2017-08-02 13:14:40 +0200",
        ""
      ]

      expect { Sem::Views::Projects.info(project1) }.to output(msg.join("\n")).to_stdout
    end
  end

  describe ".create" do
    it "returns the project in table format" do
      table = [
        ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
        ["Name", "renderedtext/cli"],
        ["Created", "2017-08-01 13:14:40 +0200"],
        ["Updated", "2017-08-02 13:14:40 +0200"]
      ]

      expect(Sem::Views::Projects).to receive(:print_table).with(table)

      described_class.info(project)
    end
  end
end
