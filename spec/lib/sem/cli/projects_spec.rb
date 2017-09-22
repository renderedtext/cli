require "spec_helper"

describe Sem::CLI::Projects do
  let(:project) { StubFactory.project }

  describe "#list" do
    context "you have at least one project on semaphore" do
      let(:another_project) { StubFactory.project }
      let(:projects) { [project, another_project] }

      before { allow(Sem::API::Project).to receive(:all).and_return(projects) }

      it "lists all projects" do
        expect(Sem::Views::Projects).to receive(:list).with([project, another_project])

        sem_run("projects:list")
      end
    end

    context "no projects on semaphore" do
      before do
        allow(Sem::API::Project).to receive(:all).and_return([])
      end

      it "offers you to set up a project on semaphore" do
        expect(Sem::Views::Projects).to receive(:setup_first_project)

        sem_run("projects:list")
      end
    end
  end

  describe "#info" do
    before { allow(Sem::API::Project).to receive(:find!).with("rt/cli").and_return(project) }

    it "shows detailed information about a project" do
      expect(Sem::Views::Projects).to receive(:info).with(project)

      sem_run("projects:info rt/cli")
    end
  end

  describe Sem::CLI::Projects::SharedConfigs do
    let(:shared_config) { StubFactory.shared_config }

    before { allow(Sem::API::Project).to receive(:find!).with("rt/cli").and_return(project) }

    describe "#list" do
      context "you have at least one shared_config attached to a project" do
        let(:shared_configs) { [shared_config, StubFactory.shared_config] }

        before { allow(project).to receive(:shared_configs).and_return(shared_configs) }

        it "lists all shared configurations on the project" do
          expect(Sem::Views::SharedConfigs).to receive(:list).with(shared_configs)

          sem_run("projects:shared-configs:list rt/cli")
        end
      end

      context "no shared_configuration attached to the project" do
        before { allow(project).to receive(:shared_configs).and_return([]) }

        it "offers you to create and attach a shared configuration" do
          expect(Sem::Views::Projects).to receive(:attach_first_shared_configuration).with(project)

          sem_run("projects:shared-configs:list rt/cli")
        end
      end
    end

    describe "#add" do
      before do
        allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      end

      it "adds the shared configuration to the project" do
        expect(project).to receive(:add_shared_config).with(shared_config)

        sem_run("projects:shared-configs:add rt/cli rt/tokens")
      end
    end

    describe "#remove" do
      before do
        allow(Sem::API::SharedConfig).to receive(:find!).with("rt/tokens").and_return(shared_config)
      end

      it "adds the shared configuration to the project" do
        expect(project).to receive(:remove_shared_config).with(shared_config)

        sem_run("projects:shared-configs:remove rt/cli rt/tokens")
      end
    end

  end

end
