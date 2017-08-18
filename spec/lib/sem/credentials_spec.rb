require "spec_helper"

describe Sem::Credentials do
  let(:path) { File.expand_path(Sem::Credentials::PATH) }
  let(:auth_token) { "auth_token" }

  describe ".write" do
    it "writes to file" do
      expect(File).to receive(:write).with(path, auth_token)

      described_class.write(auth_token)
    end
  end

  describe ".read" do
    before do
      allow(File).to receive(:read).with(path).and_return(auth_token)
    end

    it "returns the token" do
      return_value = described_class.read

      expect(return_value).to eql(auth_token)
    end
  end
end
