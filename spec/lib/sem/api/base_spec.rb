require "spec_helper"

describe Sem::API::Base do
  let(:sem_api_base) { subject }

  describe "#client" do
    let(:path) { File.expand_path(Sem::API::Base::CREDENTIALS_PATH) }
    let(:auth_token) { "auth_token" }
    let(:client) { instance_double(SemaphoreClient) }

    before do
      allow(File).to receive(:read).and_return(auth_token)
      allow(SemaphoreClient).to receive(:new).and_return(client)
    end

    it "reads the credentials file" do
      expect(File).to receive(:read).with(path)

      sem_api_base.send(:client)
    end

    it "creates the client" do
      expect(SemaphoreClient).to receive(:new).with(auth_token)

      sem_api_base.send(:client)
    end

    it "returns the client" do
      return_value = sem_api_base.send(:client)

      expect(return_value).to eql(client)
    end
  end
end
