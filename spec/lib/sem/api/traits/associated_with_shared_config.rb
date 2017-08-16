shared_examples "associated_with_shared_config" do
  let(:shared_config_id) { 0 }
  let(:shared_config_path) { "org/shared_config" }
  let(:shared_config) { { :id => shared_config_id } }

  describe ".list_for_shared_config" do
    before do
      allow(Sem::API::SharedConfigs).to receive(:info).and_return(shared_config)
      allow(class_api).to receive(:list_for_shared_config).and_return([instance])
    end

    it "calls info on sem_api_shared_configs" do
      expect(Sem::API::SharedConfigs).to receive(:info).with(shared_config_path)

      described_class.list_for_shared_config(shared_config_path)
    end

    it "calls list_for_shared_config on the class_api" do
      expect(class_api).to receive(:list_for_shared_config).with(shared_config_id)

      described_class.list_for_shared_config(shared_config_path)
    end

    it "converts the instances to instance hashes" do
      expect(described_class).to receive(:to_hash).with(instance)

      described_class.list_for_shared_config(shared_config_path)
    end

    it "returns the instance hashes" do
      return_value = described_class.list_for_shared_config(shared_config_path)

      expect(return_value).to eql([instance_hash])
    end
  end

  describe ".add_to_shared_config" do
    let(:params) { { "name" => "instance" } }

    before do
      allow(Sem::API::SharedConfigs).to receive(:info).and_return(shared_config)
      allow(class_api).to receive(:create_for_shared_config)
    end

    it "calls info on the sem_api_shared_configs" do
      expect(Sem::API::SharedConfigs).to receive(:info).with(shared_config_path)

      described_class.add_to_shared_config(shared_config_path, params)
    end

    it "calls create_for_shared_config on the class_api" do
      expect(class_api).to receive(:create_for_shared_config).with(shared_config_id, params)

      described_class.add_to_shared_config(shared_config_path, params)
    end
  end

  describe ".remove_from_shared_config" do
    before do
      allow(described_class).to receive(:list_for_shared_config).and_return([instance_hash])
      allow(class_api).to receive(:delete)
    end

    it "calls list_for_shared_config on the described class" do
      expect(described_class).to receive(:list_for_shared_config).with(shared_config_path)

      described_class.remove_from_shared_config(shared_config_path, instance_name)
    end

    it "calls delete on the class_api" do
      expect(class_api).to receive(:delete).with(instance_id)

      described_class.remove_from_shared_config(shared_config_path, instance_name)
    end
  end
end
