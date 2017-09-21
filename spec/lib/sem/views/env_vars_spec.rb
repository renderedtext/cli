require "spec_helper"

describe Sem::Views::EnvVars do
  let(:env_var) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "GEM_TOKEN",
      :encrypted? => true,
      :content => "content"
    }
  end

  describe ".list" do
    it "returns the env vars in table format" do
      expected_value = [
        ["ID", "NAME", "ENCRYPTED?", "CONTENT"],
        [env_var[:id], env_var[:name], env_var[:encrypted?], env_var[:content]]
      ]

      expect(Sem::Views::EnvVars).to receive(:print_table).with(expected_value)

      described_class.list([env_var])
    end
  end
end
