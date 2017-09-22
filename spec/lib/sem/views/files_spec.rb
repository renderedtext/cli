require "spec_helper"

describe Sem::Views::Files do
  let(:file1) { StubFactory.file(:path => "/etc/a") }
  let(:file2) { StubFactory.file(:name => "/var/b") }

  describe ".list" do
    it "prints the files in table format" do
      msg = [
        "ID                                    PATH              ENCRYPTED?",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  /etc/a            true",
        "3bc7ed43-ac8a-487e-b488-c38bc757a034  /var/secrets.txt  true",
        ""
      ]

      expect { Sem::Views::Files.list([file1, file2]) }.to output(msg.join("\n")).to_stdout
    end
  end
end
