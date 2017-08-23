require "spec_helper"

describe Sem::Views::Projects do
  let(:project) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "cli",
      :org => "renderedtext",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe ".list" do
    it "returns the projects in table format" do
      expected_value = [
        ["ID", "NAME"],
        ["3bc7ed43-ac8a-487e-b488-c38bc757a034", "renderedtext/cli"]
      ]

      expect(Sem::Views::Projects).to receive(:print_table).with(expected_value)

      described_class.list([project])
    end
  end

  describe ".info" do
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
