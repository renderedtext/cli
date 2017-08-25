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
        expected_message = "Org \"\" not found."

        expect { described_class.parse_org(nil) }.to raise_exception(Sem::Errors::InvalidSRN, expected_message)
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
        expected_message = "Team \"team\" not found."

        expect { described_class.parse_team("team") }.to raise_exception(Sem::Errors::InvalidSRN, expected_message)
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
        expected_message = "Project \"project\" not found."

        expect { described_class.parse_project("project") }.to raise_exception(Sem::Errors::InvalidSRN,
                                                                               expected_message)
      end
    end
  end

  describe ".parse_shared_config" do
    context "format is valid" do
      it "returns the org and shared config names" do
        return_value = described_class.parse_shared_config("org/shared_config")

        expect(return_value).to eql(["org", "shared_config"])
      end
    end

    context "format is invalid" do
      it "raises an exception" do
        expected_message = "Shared config \"shared_config\" not found."

        expect { described_class.parse_shared_config("shared_config") }.to raise_exception(Sem::Errors::InvalidSRN,
                                                                                           expected_message)
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
        expected_message = "User \"\" not found."

        expect { described_class.parse_user(nil) }.to raise_exception(Sem::Errors::InvalidSRN,
                                                                      expected_message)
      end
    end
  end
end
