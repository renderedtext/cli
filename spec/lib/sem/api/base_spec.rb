require "spec_helper"

describe Sem::API::Base do
  let(:sem_api_base) { subject }

  describe ".client" do
    let(:auth_token) { "auth_token" }
    let(:client) { instance_double(SemaphoreClient) }

    before do
      allow(Sem::Credentials).to receive(:read).and_return(auth_token)
      allow(SemaphoreClient).to receive(:new).with(auth_token).and_return(client)
    end

    it "returns the client" do
      return_value = described_class.client

      expect(return_value).to eql(client)
    end

    after { described_class.instance_variable_set(:@client, nil) }
  end

  describe ".check_path_length" do
    context "path format is correct" do
      it "doesn't raise an exception" do
        expect { described_class.check_path_format("org/team", "org/team") }.not_to raise_exception
      end
    end

    context "path format is not correct" do
      it "raises an exception" do
        expect { described_class.check_path_format("team", "org/team") }.to raise_exception(Sem::Errors::InvalidPath)
      end
    end
  end
end
