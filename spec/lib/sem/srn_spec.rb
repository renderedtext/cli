require "spec_helper"

describe Sem::SRN do
  describe ".parse_org" do
    context "format is valid" do
      it "returns the org name" do
        return_value = described_class.parse_org("org")

        expect(return_value).to eql(["org"])
      end
    end

    context "format is invalid" do
      it "raises an exception" do
        expect { described_class.parse_org(nil) }.to raise_exception(Sem::Errors::InvalidSRN)
      end
    end
  end

  describe ".parse_team" do
    context "format is valid" do
      it "returns the org and team names" do
        return_value = described_class.parse_team("org/team")

        expect(return_value).to eql(["org", "team"])
      end
    end

    context "format is invalid" do
      it "raises an exception" do
        expect { described_class.parse_team("team") }.to raise_exception(Sem::Errors::InvalidSRN)
      end
    end
  end

  describe ".parse_project" do
    context "format is valid" do
      it "returns the org and project names" do
        return_value = described_class.parse_project("org/project")

        expect(return_value).to eql(["org", "project"])
      end
    end

    context "format is invalid" do
      it "raises an exception" do
        expect { described_class.parse_project("project") }.to raise_exception(Sem::Errors::InvalidSRN)
      end
    end
  end

  describe ".parse_secret" do
    context "format is valid" do
      it "returns the org and secret names" do
        return_value = described_class.parse_secret("rt/tokens")

        expect(return_value).to eql(["rt", "tokens"])
      end
    end

    context "format is invalid" do
      it "raises an exception" do
        expect { described_class.parse_secret("tokens") }.to raise_exception(Sem::Errors::InvalidSRN)
      end
    end
  end

  describe ".parse_user" do
    context "format is valid" do
      it "returns the user name" do
        return_value = described_class.parse_user("user")

        expect(return_value).to eql(["user"])
      end
    end

    context "format is invalid" do
      it "raises an exception" do
        expect { described_class.parse_user(nil) }.to raise_exception(Sem::Errors::InvalidSRN)
      end
    end
  end
end
