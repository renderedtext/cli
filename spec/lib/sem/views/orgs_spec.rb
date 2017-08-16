require "spec_helper"

describe Sem::Views::Orgs do
  let(:org) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "renderedtext",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe ".list" do
    it "displays a table of orgs" do
      table = [
        ["ID", "NAME"],
        ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext"]
      ]

      expect(Sem::Views::Orgs).to receive(:print_table).with(table)

      described_class.list([org])
    end
  end

  describe ".info" do
    it "returns the org in table format" do
      table = [
        ["ID", "3bc7ed43-ac8a-487e-b488-c38bc757a034"],
        ["Name", "renderedtext"],
        ["Created", "2017-08-01 13:14:40 +0200"],
        ["Updated", "2017-08-02 13:14:40 +0200"]
      ]

      expect(Sem::Views::Orgs).to receive(:print_table).with(table)

      described_class.info(org)
    end
  end
end
