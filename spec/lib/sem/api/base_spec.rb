require "spec_helper"

describe Sem::API::Base do
  describe "#client" do
    let(:auth_token) { "auth_token" }
    let(:client) { double(SemaphoreClient) }

    before do
      allow(File).to receive(:read).and_return(auth_token)
      allow(SemaphoreClient).to receive(:new).and_return(client)
    end

    it "reads the credentials file" do
      expect(File).to receive(:read).with(Sem::API::Base::CREDENTIALS_PATH)

      subject.send(:client)
    end

    it "creates the client" do
      expect(SemaphoreClient).to receive(:new).with(auth_token)

      subject.send(:client)
    end

    it "returns the client" do
      return_value = subject.send(:client)

      expect(return_value).to eql(client)
    end
  end
end
