require "spec_helper"

describe Sem::Credentials do
  let(:path) { File.expand_path(Sem::Credentials::PATH) }
  let(:auth_token) { "auth_token" }

  describe ".write" do
    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:write)
      allow(File).to receive(:chmod)
    end

    it "creates the .sem directory" do
      expect(FileUtils).to receive(:mkdir_p).with(File.dirname(path))

      described_class.write(auth_token)
    end

    it "writes to file" do
      expect(File).to receive(:write).with(path, auth_token)

      described_class.write(auth_token)
    end

    it "sets permissions on the file" do
      expect(File).to receive(:chmod).with(0o0600, path)

      described_class.write(auth_token)
    end
  end

  describe ".read" do
    context "credentials file exists" do
      before do
        allow(File).to receive(:file?).with(path).and_return(true)
        allow(File).to receive(:read).with(path).and_return(auth_token)
      end

      it "returns the token" do
        return_value = described_class.read

        expect(return_value).to eql(auth_token)
      end
    end

    context "credentials file doesn't exist" do
      before { allow(File).to receive(:file?).with(path).and_return(false) }

      it "raises the NoCredentials error" do
        expect { described_class.read }.to raise_exception(Sem::Errors::Auth::NoCredentials)
      end
    end
  end

  describe ".delete" do
    it "deletes the file" do
      expect(FileUtils).to receive(:rm_f).with(path)

      described_class.delete
    end
  end
end
