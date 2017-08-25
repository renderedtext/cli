shared_examples "associated_with_team" do
  let(:team_id) { 0 }

  before { allow(Sem::API::Teams).to receive(:name_to_id).and_return(team_id) }

  describe "interface requirements" do
    it "has .name_to_id method" do
      expect(described_class).to respond_to(:name_to_id)
    end

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
    before { allow(class_api).to receive(:list_for_team).and_return([instance]) }

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:name_to_id).with(org_name, team_name)

      described_class.list_for_team(org_name, team_name)
    end

    it "calls list_for_team on the class_api" do
      expect(class_api).to receive(:list_for_team).with(team_id)

      described_class.list_for_team(org_name, team_name)
    end

    it "converts the instances to instance hashes" do
      expect(described_class).to receive(:to_hash).with(instance, org_name)

      described_class.list_for_team(org_name, team_name)
    end

    it "returns the instance hashes" do
      return_value = described_class.list_for_team(org_name, team_name)

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".add_to_team" do
    before do
      allow(described_class).to receive(:name_to_id).and_return(instance_id)
      allow(class_api).to receive(:attach_to_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:name_to_id).with(org_name, instance_name)

      described_class.add_to_team(org_name, team_name, instance_name)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:name_to_id).with(org_name, team_name)

      described_class.add_to_team(org_name, team_name, instance_name)
    end

    it "calls attach_to_team on the class_api" do
      expect(class_api).to receive(:attach_to_team).with(instance_id, team_id)

      described_class.add_to_team(org_name, team_name, instance_name)
    end
  end

  describe ".remove_from_team" do
    before do
      allow(described_class).to receive(:name_to_id).and_return(instance_id)
      allow(class_api).to receive(:detach_from_team)
    end

    it "calls info on the described class" do
      expect(described_class).to receive(:name_to_id).with(org_name, instance_name)

      described_class.remove_from_team(org_name, team_name, instance_name)
    end

    it "calls info on sem_api_teams" do
      expect(Sem::API::Teams).to receive(:name_to_id).with(org_name, team_name)

      described_class.remove_from_team(org_name, team_name, instance_name)
    end

    it "calls detach_from_team on the class_api" do
      expect(class_api).to receive(:detach_from_team).with(instance_id, team_id)

      described_class.remove_from_team(org_name, team_name, instance_name)
    end
  end
end
