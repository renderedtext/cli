require "spec_helper"

describe Sem::Views::Teams do
  let(:team) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "developers",
      :org => "renderedtext",
      :permission => "write",
      :members => "72",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe ".list" do
    it "displays a table of teams" do
      table = [
        ["ID", "NAME", "PERMISSION", "MEMBERS"],
        ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext/developers", "write", "72 members"]
      ]

      expect(Sem::Views::Teams).to receive(:print_table).with(table)

      described_class.list([team])
    end
  end

  describe ".info" do
    it "returns the team in table format" do
      table = [
        ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
        ["Name", "renderedtext/developers"],
        ["Permission", "write"],
        ["Members", "72 members"],
        ["Created", "2017-08-01 13:14:40 +0200"],
        ["Updated", "2017-08-02 13:14:40 +0200"]
      ]

      expect(Sem::Views::Teams).to receive(:print_table).with(table)

      described_class.info(team)
    end
  end
end
