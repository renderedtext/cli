require "spec_helper"

describe Sem::Views::Files do
  let(:file1) { StubFactory.file(:path => "a.txt") }
  let(:file2) { StubFactory.file(:path => ".ssh/is_rsa.pub") }

  describe ".list" do
    it "prints the files in table format" do
      msg = [
        "ID                                    PATH                          ENCRYPTED?",
        "77c7ed43-ac8a-487e-b488-c38bc757a034  /home/runner/a.txt            true",
        "77c7ed43-ac8a-487e-b488-c38bc757a034  /home/runner/.ssh/is_rsa.pub  true",
        ""
      ]

      expect { Sem::Views::Files.list([file1, file2]) }.to output(msg.join("\n")).to_stdout
    end
  end
end
