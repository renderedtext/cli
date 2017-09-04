require "spec_helper"

describe Sem::Helpers::Git do

  describe ".parse_url" do
    context "when git url is valid" do
      it "returns url segments" do
        repo_provider, repo_owner, repo_name = described_class.parse_url("git@github.com:renderedtext/cli.git")

        expect(repo_provider).to eq("github")
        expect(repo_owner).to eq("renderedtext")
        expect(repo_name).to eq("cli")
      end
    end

    context "when git url is invalid" do
      it "raises an error" do
        expect { described_class.parse_url("lol") }.to raise_exception(Sem::Helpers::Git::InvalidGitUrl)
      end
    end
  end

end
