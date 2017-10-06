require "spec_helper"

describe Sem::Helpers::GitUrl do

  context "initiated with ssh git url" do
    subject(:url) { Sem::Helpers::GitUrl.new("git@github.com:renderedtext/cli.git") }

    it { is_expected.to be_valid }

    it { expect(url.repo_name).to eq("cli") }
    it { expect(url.repo_owner).to eq("renderedtext") }
    it { expect(url.repo_provider).to eq("github") }
  end

  context "initiated with http github url" do
    subject(:url) { Sem::Helpers::GitUrl.new("https://github.com/renderedtext/cli") }

    it { is_expected.to be_valid }

    it { expect(url.repo_name).to eq("cli") }
    it { expect(url.repo_owner).to eq("renderedtext") }
    it { expect(url.repo_provider).to eq("github") }
  end

  context "initiated with http githut url without protocol" do
    subject(:url) { Sem::Helpers::GitUrl.new("github.com/renderedtext/cli") }

    it { is_expected.to be_valid }

    it { expect(url.repo_name).to eq("cli") }
    it { expect(url.repo_owner).to eq("renderedtext") }
    it { expect(url.repo_provider).to eq("github") }
  end

  context "initiated with http bitbucket url" do
    subject(:url) { Sem::Helpers::GitUrl.new("bitbucket.org/renderedtext/cli") }

    it { is_expected.to be_valid }

    it { expect(url.repo_name).to eq("cli") }
    it { expect(url.repo_owner).to eq("renderedtext") }
    it { expect(url.repo_provider).to eq("bitbucket") }
  end

  context "initiated with invalid url" do
    subject(:url) { Sem::Helpers::GitUrl.new("github.com:renderedtext/cli") }

    it { is_expected.to_not be_valid }

    it { expect(url.repo_name).to be_nil }
    it { expect(url.repo_owner).to be_nil }
    it { expect(url.repo_provider).to be_nil }
  end

end
