require "spec_helper"

describe Sem::CLI::Teams do
  let(:team) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "developers",
      :org => "renderedtext",
      :permission => "write",
      :members => "72",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    context "when the user has several teams" do
      let(:another_team) do
        {
          :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0",
          :name => "developers",
          :org => "tb-render",
          :permission => "admin",
          :members => "3"
        }
      end

      before { allow(Sem::API::Teams).to receive(:list).and_return([team, another_team]) }

      it "calls the API" do
        expect(Sem::API::Teams).to receive(:list)

        sem_run("teams:list")
      end

      it "lists the teams" do
        stdout, stderr, status = sem_run("teams:list")

        msg = [
          "ID                                    NAME                     PERMISSION  MEMBERS",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/developers  write       72 members",
          "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  tb-render/developers     admin       3 members"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

    context "when the user doesn't have any team" do
      before { allow(Sem::API::Teams).to receive(:list).and_return([]) }

      it "offers you to set up a team on sempaphore" do
        stdout, stderr, status = sem_run("teams:list")

        msg = [
          "You don't have any teams on Semaphore.",
          "",
          "Create your first team:",
          "",
          "  sem teams:create ORG_NAME/TEAM",
          "",
          ""
        ]

        expect(stdout).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end
  end

  describe "#info" do
    before { allow(Sem::API::Teams).to receive(:info).and_return(team) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:info).with("renderedtext", "developers")

      sem_run("teams:info renderedtext/developers")
    end

    it "shows information about a team" do
      stdout, stderr, status = sem_run("teams:info renderedtext/developers")

      msg = [
        "ID          3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        renderedtext/developers",
        "Permission  write",
        "Members     72 members",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
      expect(status).to eq(:ok)
    end
  end

  describe "#create" do
    before { allow(Sem::API::Teams).to receive(:create).and_return(team) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:create).with("renderedtext", :name => "developers", :permission => "write")

      sem_run("teams:create renderedtext/developers --permission write")
    end

    it "creates a team and displays it" do
      stdout, stderr, status = sem_run("teams:create renderedtext/developers --permission write")

      msg = [
        "ID          3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        renderedtext/developers",
        "Permission  write",
        "Members     72 members",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
      expect(status).to eq(:ok)
    end
  end

  describe "#rename" do
    before { allow(Sem::API::Teams).to receive(:update).and_return(team) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:update).with("renderedtext", "admins", :name => "developers")

      sem_run("teams:rename renderedtext/admins renderedtext/developers")
    end

    context "org names are not matching" do
      it "raises an exception" do
        stdout, stderr, status = sem_run("teams:rename renderedtext/admins org/developers")

        msg = [
          "[ERROR] Organization names not matching.",
          "",
          "Old team name \"renderedtext/admins\" and new team name \"org/developers\" are not in the same organization."
        ]

        expect(stderr.strip).to eq(msg.join("\n"))
        expect(stdout.strip).to eq("")
        expect(status).to eq(:system_error)
      end
    end

    it "changes the team name" do
      stdout, stderr, status = sem_run("teams:rename renderedtext/developers renderedtext/admins")

      msg = [
        "ID          3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        renderedtext/developers",
        "Permission  write",
        "Members     72 members",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
      expect(status).to eq(:ok)
    end
  end

  describe "#set-permission" do
    before { allow(Sem::API::Teams).to receive(:update).and_return(team) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:update).with("renderedtext", "developers", :permission => "admin")

      sem_run("teams:set-permission renderedtext/developers admin")
    end

    context "setting an invalid permission" do
      it "raises an exception" do
        stdout, stderr, status = sem_run("teams:set-permission renderedtext/developers something")

        expected_message = "Permission \"something\" doesn't exist.\n" \
          "Choose one of the following: read, write, admin."

        expect(stderr.strip).to eql(expected_message)
        expect(stdout.strip).to eql("")
        expect(status).to eq(:system_error)
      end
    end

    it "sets the permisssion level of the team" do
      stdout, stderr, status = sem_run("teams:set-permission renderedtext/developers write")

      msg = [
        "ID          3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name        renderedtext/developers",
        "Permission  write",
        "Members     72 members",
        "Created     2017-08-01 13:14:40 +0200",
        "Updated     2017-08-02 13:14:40 +0200"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
      expect(status).to eq(:ok)
    end
  end

  describe "#delete" do
    before { allow(Sem::API::Teams).to receive(:delete) }

    it "calls the API" do
      expect(Sem::API::Teams).to receive(:delete).with("renderedtext", "old-developers")

      sem_run("teams:delete renderedtext/old-developers")
    end

    it "deletes the team" do
      stdout, stderr, status = sem_run("teams:delete renderedtext/old-developers")

      msg = [
        "Deleted team renderedtext/old-developers"
      ]

      expect(stderr).to eq("")
      expect(stdout.strip).to eq(msg.join("\n"))
      expect(status).to eq(:ok)
    end
  end

  describe Sem::CLI::Teams::Members do
    describe "#list" do
      context "when the team has several members" do
        let(:user_0) { { :id => "ijovan" } }
        let(:user_1) { { :id => "shiroyasha" } }

        before { allow(Sem::API::Users).to receive(:list_for_team).and_return([user_0, user_1]) }

        it "calls the users API" do
          expect(Sem::API::Users).to receive(:list_for_team).with("renderedtext", "cli")

          sem_run("teams:members:list renderedtext/cli")
        end

        it "lists team members" do
          stdout, stderr, status = sem_run("teams:members:list renderedtext/cli")

          msg = [
            "NAME",
            "ijovan",
            "shiroyasha"
          ]

          expect(stderr).to eq("")
          expect(stdout.strip).to eq(msg.join("\n"))
          expect(status).to eq(:ok)
        end
      end

      context "when the team has no members" do
        before { allow(Sem::API::Users).to receive(:list_for_team).and_return([]) }

        it "offers help adding your first member" do
          stdout, stderr, status = sem_run("teams:members:list renderedtext/devs")

          msg = [
            "You don't have any members in the team.",
            "",
            "Add your first member:",
            "",
            "  sem teams:members:add renderedtext/devs USERNAME",
            "",
            ""
          ]

          expect(stderr).to eq("")
          expect(stdout).to eq(msg.join("\n"))
          expect(status).to eq(:ok)
        end
      end
    end

    describe "#add" do
      before { allow(Sem::API::Users).to receive(:add_to_team) }

      it "calls the users API" do
        expect(Sem::API::Users).to receive(:add_to_team).with("renderedtext", "developers", "ijovan")

        sem_run("teams:members:add renderedtext/developers ijovan")
      end

      it "add a user to the team" do
        stdout, stderr, status = sem_run("teams:members:add renderedtext/developers ijovan")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("User ijovan added to the team.")
        expect(status).to eq(:ok)
      end
    end

    describe "#remove" do
      before { allow(Sem::API::Users).to receive(:remove_from_team) }

      it "calls the users API" do
        expect(Sem::API::Users).to receive(:remove_from_team).with("renderedtext", "developers", "ijovan")

        sem_run("teams:members:remove renderedtext/developers ijovan")
      end

      it "removes a user from the team" do
        stdout, stderr, status = sem_run("teams:members:remove renderedtext/developers ijovan")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("User ijovan removed from the team.")
        expect(status).to eq(:ok)
      end
    end
  end

  describe Sem::CLI::Teams::Projects do
    describe "#list" do
      let(:project_0) { { :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034", :name => "cli", :org => "renderedtext" } }
      let(:project_1) { { :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", :name => "api", :org => "renderedtext" } }

      before { allow(Sem::API::Projects).to receive(:list_for_team).and_return([project_0, project_1]) }

      it "calls the projects API" do
        expect(Sem::API::Projects).to receive(:list_for_team).with("renderedtext", "cli")

        sem_run("teams:projects:list renderedtext/cli")
      end

      it "lists projects in the team" do
        stdout, stderr, status = sem_run("teams:projects:list renderedtext/cli")

        msg = [
          "ID                                    NAME",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/cli",
          "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  renderedtext/api"
        ]

        expect(stderr).to eq("")
        expect(stdout.strip).to eq(msg.join("\n"))
        expect(status).to eq(:ok)
      end
    end

    describe "#add" do
      before { allow(Sem::API::Projects).to receive(:add_to_team) }

      it "calls the projects API" do
        expect(Sem::API::Projects).to receive(:add_to_team).with("renderedtext", "developers", "cli")

        sem_run("teams:projects:add renderedtext/developers renderedtext/cli")
      end

      context "org names are not matching" do
        it "raises an exception" do
          stdout, stderr, status = sem_run("teams:projects:add renderedtext/developers org/cli")

          msg = [
            "[ERROR] Organization names not matching.",
            "",
            "Team \"renderedtext/developers\" and project \"org/cli\" are not in the same organization."
          ]

          expect(stderr.strip).to eq(msg.join("\n"))
          expect(stdout.strip).to eq("")
          expect(status).to eq(:system_error)
        end
      end

      it "add a project to the team" do
        stdout, stderr, status = sem_run("teams:projects:add renderedtext/developers renderedtext/cli")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Project renderedtext/cli added to the team.")
        expect(status).to eq(:ok)
      end
    end

    describe "#remove" do
      before { allow(Sem::API::Projects).to receive(:remove_from_team) }

      it "calls the projects API" do
        expect(Sem::API::Projects).to receive(:remove_from_team).with("renderedtext", "developers", "api")

        sem_run("teams:projects:remove renderedtext/developers renderedtext/api")
      end

      context "org names are not matching" do
        it "raises an exception" do
          stdout, stderr, status = sem_run("teams:projects:remove renderedtext/developers org/api")

          msg = [
            "[ERROR] Organization names not matching.",
            "",
            "Team \"renderedtext/developers\" and project \"org/api\" are not in the same organization."
          ]

          expect(stderr.strip).to eq(msg.join("\n"))
          expect(stdout.strip).to eq("")
          expect(status).to eq(:system_error)
        end
      end

      it "removes a project from the team" do
        stdout, stderr, status = sem_run("teams:projects:remove renderedtext/developers renderedtext/api")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Project renderedtext/api removed from the team.")
        expect(status).to eq(:ok)
      end
    end
  end

  describe Sem::CLI::Teams::SharedConfigs do
    describe "#list" do
      let(:config_0) do
        {
          :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
          :org => "renderedtext",
          :name => "aws-tokens",
          :config_files => 2,
          :env_vars => 1
        }
      end

      let(:config_1) do
        {
          :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0",
          :org => "renderedtext",
          :name => "gemfury",
          :config_files => 1,
          :env_vars => 2
        }
      end

      before { allow(Sem::API::SharedConfigs).to receive(:list_for_team).and_return([config_0, config_1]) }

      it "calls the configs API" do
        expect(Sem::API::SharedConfigs).to receive(:list_for_team).with("renderedtext", "aws-tokens")

        sem_run("teams:shared-configs:list renderedtext/aws-tokens")
      end

      it "lists shared configurations in the team" do
        stdout, stderr, status = sem_run("teams:shared-configs:list renderedtext/aws-tokens")

        msg = [
          "ID                                    NAME                     CONFIG FILES  ENV VARS",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/aws-tokens             2         1",
          "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  renderedtext/gemfury                1         2"
        ]

        expect(stderr).to eq("")
        expect(stdout.strip).to eq(msg.join("\n"))
        expect(status).to eq(:ok)
      end
    end

    describe "#add" do
      before { allow(Sem::API::SharedConfigs).to receive(:add_to_team) }

      it "calls the projects API" do
        expect(Sem::API::SharedConfigs).to receive(:add_to_team).with("rt", "developers", "aws-tokens")

        sem_run("teams:shared-configs:add rt/developers rt/aws-tokens")
      end

      context "org names are not matching" do
        it "raises an exception" do
          stdout, stderr, status = sem_run("teams:shared-configs:add rt/developers org/aws-tokens")

          msg = [
            "[ERROR] Organization names not matching.",
            "",
            "Team \"rt/developers\" and shared configuration \"org/aws-tokens\" are not in the same organization."
          ]

          expect(stderr.strip).to eq(msg.join("\n"))
          expect(stdout.strip).to eq("")
          expect(status).to eq(:system_error)
        end
      end

      it "add a project to the team" do
        stdout, stderr, status = sem_run("teams:shared-configs:add renderedtext/developers renderedtext/aws-tokens")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Shared Configuration renderedtext/aws-tokens added to the team.")
        expect(status).to eq(:ok)
      end
    end

    describe "#remove" do
      before { allow(Sem::API::SharedConfigs).to receive(:remove_from_team) }

      it "calls the projects API" do
        expect(Sem::API::SharedConfigs).to receive(:remove_from_team).with("rt", "developers", "tokens")

        sem_run("teams:shared-configs:remove rt/developers rt/tokens")
      end

      context "org names are not matching" do
        it "raises an exception" do
          stdout, stderr, status = sem_run("teams:shared-configs:remove rt/developers org/tokens")

          msg = [
            "[ERROR] Organization names not matching.",
            "",
            "Team \"rt/developers\" and shared configuration \"org/tokens\" are not in the same organization."
          ]

          expect(stderr.strip).to eq(msg.join("\n"))
          expect(stdout.strip).to eq("")
          expect(status).to eq(:system_error)
        end
      end

      it "removes a project from the team" do
        stdout, stderr, status = sem_run("teams:shared-configs:remove renderedtext/developers renderedtext/aws-tokens")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Shared Configuration renderedtext/aws-tokens removed from the team.")
        expect(status).to eq(:ok)
      end
    end
  end
end
