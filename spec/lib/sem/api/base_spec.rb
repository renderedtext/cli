require "spec_helper"

describe Sem::API::Base do
  let(:sem_api_base) { subject }

  describe ".client" do
    let(:auth_token) { "auth_token" }
    let(:api_url) { "api_url" }
    let(:client) { instance_double(SemaphoreClient) }

    before do
      options = { :api_url => api_url, :verbose => (Sem.log_level == Sem::LOG_LEVEL_TRACE) }

      allow(Sem::Configuration).to receive(:auth_token).and_return(auth_token)
      allow(Sem::Configuration).to receive(:api_url).and_return(api_url)
      allow(SemaphoreClient).to receive(:new).with(auth_token, options).and_return(client)
    end

    it "returns the client" do
      return_value = described_class.client

      expect(return_value).to eql(client)
    end

    after { described_class.instance_variable_set(:@client, nil) }
  end

  describe ".raise_not_found" do
    it "raises the exception with the resource path" do
      expect { described_class.raise_not_found("Resource", ["org", "team"]) }.to raise_exception(
        Sem::Errors::Resource::NotFound,
        "Resource org/team not found."
      )
    end
  end
end
