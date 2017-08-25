require "spec_helper"

describe Sem::CLI::Projects do
  let(:project) do
    {
      :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
      :name => "cli",
      :org => "renderedtext",
      :created_at => "2017-08-01 13:14:40 +0200",
      :updated_at => "2017-08-02 13:14:40 +0200"
    }
  end

  describe "#list" do
    let(:another_project) { { :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0", :name => "api", :org => "tb-render" } }

    context "you have at least one project on semaphore" do
      before do
        allow(Sem::API::Projects).to receive(:list).and_return([project, another_project])
      end

      it "calls the API" do
        expect(Sem::API::Projects).to receive(:list)

        sem_run("projects:list")
      end

      it "lists projects" do
        stdout, stderr, status = sem_run("projects:list")

        msg = [
          "ID                                    NAME",
          "3bc7ed43-ac8a-487e-b488-c38bc757a034  renderedtext/cli",
          "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0  tb-render/api"
        ]

        expect(stdout.strip).to eq(msg.join("\n"))
        expect(stderr).to eq("")
        expect(status).to eq(:ok)
      end
    end

    context "no projects on semaphore" do
      before do
        allow(Sem::API::Projects).to receive(:list).and_return([])
      end

      it "offers you to set up a project on sempaphore" do
        stdout, stderr, status = sem_run("projects:list")

        msg = [
          "You don't have any project configured on Semaphore.",
          "",
          "Add your first project: https://semaphoreci.com/new",
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
    before { allow(Sem::API::Projects).to receive(:info).and_return(project) }

    it "calls the API" do
      expect(Sem::API::Projects).to receive(:info).with("renderedtext", "cli")

      sem_run("projects:info renderedtext/cli")
    end

    it "shows detailed information about an organization" do
      stdout, stderr, status = sem_run("projects:info renderedtext/cli")

      msg = [
        "ID       3bc7ed43-ac8a-487e-b488-c38bc757a034",
        "Name     renderedtext/cli",
        "Created  2017-08-01 13:14:40 +0200",
        "Updated  2017-08-02 13:14:40 +0200"
      ]

      expect(stdout.strip).to eq(msg.join("\n"))
      expect(stderr).to eq("")
      expect(status).to eq(:ok)
    end
  end

  describe Sem::CLI::Projects::SharedConfigs do
    describe "#list" do
      let(:config_0) do
        {
          :id => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
          :name => "renderedtext/aws-tokens",
          :config_files => 2,
          :env_vars => 1
        }
      end

      let(:config_1) do
        {
          :id => "fe3624cf-0cea-4d87-9dde-cb9ddacfefc0",
          :name => "renderedtext/gemfury",
          :config_files => 1,
          :env_vars => 2
        }
      end

      before { allow(Sem::API::SharedConfigs).to receive(:list_for_project).and_return([config_0, config_1]) }

      it "calls the configs API" do
        expect(Sem::API::SharedConfigs).to receive(:list_for_project).with("renderedtext", "prj1")

        sem_run("projects:shared-configs:list renderedtext/prj1")
      end

      it "lists shared configurations on a project" do
        stdout, stderr, status = sem_run("projects:shared-configs:list renderedtext/prj1")

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
      before { allow(Sem::API::SharedConfigs).to receive(:add_to_project) }

      it "calls the projects API" do
        expect(Sem::API::SharedConfigs).to receive(:add_to_project).with("rt", "prj1", "aws-tokens")

        sem_run("projects:shared-configs:add rt/prj1 rt/aws-tokens")
      end

      context "org names are not matching" do
        it "raises an exception" do
          stdout, stderr, status = sem_run("projects:shared-configs:add rt/prj1 org/aws-tokens")

          msg = [
            "[ERROR] Organization names not matching.",
            "",
            "Project \"rt/prj1\" and shared configuration \"org/aws-tokens\" are not in the same organization."
          ]

          expect(stderr.strip).to eq(msg.join("\n"))
          expect(stdout.strip).to eq("")
          expect(status).to eq(:system_error)
        end
      end

      it "add a project to the team" do
        stdout, stderr, status = sem_run("projects:shared-configs:add rt/prj1 rt/aws-tokens")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Shared Configuration rt/aws-tokens added to the project.")
        expect(status).to eq(:ok)
      end
    end

    describe "#remove" do
      before { allow(Sem::API::SharedConfigs).to receive(:remove_from_project) }

      it "calls the projects API" do
        expect(Sem::API::SharedConfigs).to receive(:remove_from_project).with("rt", "prj1", "tokens")

        sem_run("projects:shared-configs:remove rt/prj1 rt/tokens")
      end

      context "org names are not matching" do
        it "raises an exception" do
          stdout, stderr, status = sem_run("projects:shared-configs:remove rt/prj1 org/tokens")

          msg = [
            "[ERROR] Organization names not matching.",
            "",
            "Project \"rt/prj1\" and shared configuration \"org/tokens\" are not in the same organization."
          ]

          expect(stderr.strip).to eq(msg.join("\n"))
          expect(stdout.strip).to eq("")
          expect(status).to eq(:system_error)
        end
      end

      it "removes a project from the team" do
        stdout, stderr, status = sem_run("projects:shared-configs:remove rt/prj1 rt/aws-tokens")

        expect(stderr).to eq("")
        expect(stdout.strip).to eq("Shared Configuration rt/aws-tokens removed from the project.")
        expect(status).to eq(:ok)
      end
    end
  end
end
