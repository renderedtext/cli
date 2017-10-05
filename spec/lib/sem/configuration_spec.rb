require "spec_helper"

describe Sem::Configuration do
  let(:credentials_path) { File.expand_path(Sem::Configuration::CREDENTIALS_PATH) }
  let(:api_url_path) { File.expand_path(Sem::Configuration::API_URL_PATH) }
  let(:auth_token) { "vodafone" }

  describe ".valid_auth_token?" do
    context "listing orgs fails" do
      it "return false" do
        stub_api(:get, "/orgs").to_return(404, "")

        expect(Sem::Configuration.valid_auth_token?(auth_token)).to eq(false)
      end
    end

    context "listing orgs succeds" do
      it "return true" do
        stub_api(:get, "/orgs").to_return(200, [])

        expect(Sem::Configuration.valid_auth_token?(auth_token)).to eq(true)
      end
    end
  end

  describe ".export_auth_token" do
    before do
      allow(FileUtils).to receive(:mkdir_p)
      allow(File).to receive(:write)
      allow(File).to receive(:chmod)
    end

    it "creates the .sem directory" do
      dirname = File.dirname(credentials_path)

      expect(FileUtils).to receive(:mkdir_p).with(dirname)

      described_class.export_auth_token(auth_token)
    end

    it "writes to file" do
      expect(File).to receive(:write).with(credentials_path, auth_token)

      described_class.export_auth_token(auth_token)
    end

    it "sets permissions on the file" do
      expect(File).to receive(:chmod).with(0o0600, credentials_path)

      described_class.export_auth_token(auth_token)
    end
  end

  describe ".logout" do
    before do
      allow(FileUtils).to receive(:rm_f)
    end

    it "removes the file by force" do
      allow(FileUtils).to receive(:rm_f).with(Sem::Configuration::CREDENTIALS_PATH)

      described_class.delete_auth_token
    end
  end

  describe ".auth_token" do
    context "credentials file exists" do
      before do
        allow(File).to receive(:file?).with(credentials_path).and_return(true)
        allow(File).to receive(:read).with(credentials_path).and_return(auth_token)
      end

      it "returns the auth token" do
        return_value = described_class.auth_token

        expect(return_value).to eql(auth_token)
      end
    end

    context "credentials file doesn't exist" do
      before { allow(File).to receive(:file?).with(credentials_path).and_return(false) }

      it "raises the NoCredentials error" do
        expect { described_class.auth_token }.to raise_exception(Sem::Errors::Auth::NoCredentials)
      end
    end
  end

  describe ".api_url" do
    context "api_url file exists" do
      before do
        allow(File).to receive(:file?).with(api_url_path).and_return(true)
        allow(File).to receive(:read).with(api_url_path).and_return("stg1-semaphore.semaphoreci.com")
      end

      it "returns the custom api url" do
        return_value = described_class.api_url

        expect(return_value).to eql("stg1-semaphore.semaphoreci.com")
      end
    end

    context "api_url file doesn't exist" do
      before { allow(File).to receive(:file?).with(api_url_path).and_return(false) }

      it "returns the default api url" do
        return_value = described_class.api_url

        expect(return_value).to eql(Sem::Configuration::DEFAULT_API_URL)
      end
    end
  end
end
