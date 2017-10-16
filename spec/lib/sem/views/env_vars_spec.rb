require "spec_helper"

describe Sem::Views::EnvVars do
  let(:env_var1) { StubFactory.env_var(:name => "SECRET", :encrypted => false, :content => "aaa") }
  let(:env_var2) { StubFactory.env_var(:name => "TOKEN") }

  describe ".list" do
    it "prints the files in table format" do
      msg = [
        "ID                                    NAME    ENCRYPTED?  CONTENT",
        "9997ed43-ac8a-487e-b488-c38bc757a034  SECRET  false       aaa",
        "9997ed43-ac8a-487e-b488-c38bc757a034  TOKEN   true        *encrypted*",
        ""
      ]

      expect { Sem::Views::EnvVars.list([env_var1, env_var2]) }.to output(msg.join("\n")).to_stdout
    end
  end
end
