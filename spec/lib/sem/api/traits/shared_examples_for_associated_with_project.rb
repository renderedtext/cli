shared_examples "associated_with_project" do
  describe "interface requirements" do
    it "has .info method" do
      expect(described_class).to respond_to(:info)
    end

    it "has .api method" do
      expect(described_class).to respond_to(:api)
    end

    it "has .to_hash method" do
      expect(described_class).to respond_to(:to_hash)
    end
  end

  describe ".list_for_project" do
    let(:project_id) { 0 }
    let(:project) { { :id => project_id } }

    before do
      allow(Sem::API::Projects).to receive(:info).and_return(project)
      allow(class_api).to receive(:list_for_project).and_return([instance])
    end

    it "calls info on sem_api_projects" do
      expect(Sem::API::Projects).to receive(:info).with(org_name, project_name)

      described_class.list_for_project(org_name, project_name)
    end

    it "calls list_for_project on the class_api" do
      expect(class_api).to receive(:list_for_project).with(project_id)

      described_class.list_for_project(org_name, project_name)
    end

    it "converts the instances to instance hashes" do
      expect(described_class).to receive(:to_hash).with(instance, org_name)

      described_class.list_for_project(org_name, project_name)
    end

    it "returns the instance hashes" do
      return_value = described_class.list_for_project(org_name, project_name)

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".add_to_project" do
    let(:project_id) { 0 }
    let(:project) { { :id => project_id } }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(Sem::API::Projects).to receive(:info).and_return(project)
      allow(class_api).to receive(:attach_to_project)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(org_name, instance_name)

      described_class.add_to_project(org_name, project_name, instance_name)
    end

    it "calls info on sem_api_projects" do
      expect(Sem::API::Projects).to receive(:info).with(org_name, project_name)

      described_class.add_to_project(org_name, project_name, instance_name)
    end

    it "calls attach_to_project on the class_api" do
      expect(class_api).to receive(:attach_to_project).with(instance_id, project_id)

      described_class.add_to_project(org_name, project_name, instance_name)
    end
  end

  describe ".remove_from_project" do
    let(:project_id) { 0 }
    let(:project) { { :id => project_id } }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(Sem::API::Projects).to receive(:info).and_return(project)
      allow(class_api).to receive(:detach_from_project)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(org_name, instance_name)

      described_class.remove_from_project(org_name, project_name, instance_name)
    end

    it "calls info on sem_api_projects" do
      expect(Sem::API::Projects).to receive(:info).with(org_name, project_name)

      described_class.remove_from_project(org_name, project_name, instance_name)
    end

    it "calls detach_from_project on the class_api" do
      expect(class_api).to receive(:detach_from_project).with(instance_id, project_id)

      described_class.remove_from_project(org_name, project_name, instance_name)
    end
  end
end
