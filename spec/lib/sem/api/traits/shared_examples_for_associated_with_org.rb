shared_examples "associated_with_org" do
  describe "interface requirements" do
    it "has .api method" do
      expect(described_class).to respond_to(:api)
    end

    it "has .to_hash method" do
      expect(described_class).to respond_to(:to_hash)
    end
  end

  describe ".list_for_org" do
    before { allow(class_api).to receive(:list_for_org).and_return([instance]) }

    it "calls list_for_org on the class_api" do
      expect(class_api).to receive(:list_for_org).with(org_name)

      described_class.list_for_org(org_name)
    end

    it "converts the instances to instance hashes" do
      expect(described_class).to receive(:to_hash).with(instance)

      described_class.list_for_org(org_name)
    end

    it "returns the instance hashes" do
      return_value = described_class.list_for_org(org_name)

      expect(return_value).to eql([instance_hash])
    end
  end
end
