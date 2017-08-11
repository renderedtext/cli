shared_examples "belonging_to_team" do
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

  describe ".list_for_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(class_api).to receive(:list_for_team).and_return([instance])
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.list_for_team(team_path)
    end

    it "calls list_for_team on the class_api" do
      expect(class_api).to receive(:list_for_team).with(team_id)

      described_class.list_for_team(team_path)
    end

    it "converts the instances to instance hashes" do
      expect(described_class).to receive(:to_hash).with(instance)

      described_class.list_for_team(team_path)
    end

    it "returns the instance hashes" do
      return_value = described_class.list_for_team(team_path)

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".add_to_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(class_api).to receive(:attach_to_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(instance_path)

      described_class.add_to_team(team_path, instance_path)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.add_to_team(team_path, instance_path)
    end

    it "calls attach_to_team on the class_api" do
      expect(class_api).to receive(:attach_to_team).with(instance_id, team_id)

      described_class.add_to_team(team_path, instance_path)
    end
  end

  describe ".remove_from_team" do
    let(:team_id) { 0 }
    let(:team) { { :id => team_id } }

    before do
      allow(described_class).to receive(:info).and_return(instance_hash)
      allow(Sem::API::Teams).to receive(:info).and_return(team)
      allow(class_api).to receive(:detach_from_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:info).with(instance_path)

      described_class.remove_from_team(team_path, instance_path)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:info).with(team_path)

      described_class.remove_from_team(team_path, instance_path)
    end

    it "calls detach_from_team on the class_api" do
      expect(class_api).to receive(:detach_from_team).with(instance_id, team_id)

      described_class.remove_from_team(team_path, instance_path)
    end
  end
end
