require "spec_helper"

describe Sem::Credentials do
  let(:path) { File.expand_path(Sem::Credentials::PATH) }
  let(:auth_token) { "auth_token" }

  describe ".valid?" do
    before do
      @credentials = "dragonite"
      @orgs = instance_double(SemaphoreClient::Api::Org, :list! => nil)
      @client = instance_double(SemaphoreClient, :orgs => @orgs)

      allow(SemaphoreClient).to receive(:new).with(@credentials).and_return(@client)
    end

    context "listing orgs fails" do
      before do
        allow(@orgs).to receive(:list!).and_raise(SemaphoreClient::Exceptions::RequestFailed)
      end

      it "return false" do
        expect(Sem::Credentials.valid?(@credentials)).to eq(false)
      end
    end

    context "listing orgs succeds" do
      it "return true" do
        expect(Sem::Credentials.valid?(@credentials)).to eq(true)
      end
    end
  end

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
end
