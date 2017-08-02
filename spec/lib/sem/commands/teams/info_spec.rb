require "spec_helper"

describe Sem::Commands::Teams::Info do

  describe ".run" do
    context "team found" do
      it "displays the team" do
        expect(Sem::UI).to receive(:show_hash).with(
          "ID" => "3bc7ed43-ac8a-487e-b488-c38bc757a034",
          "Name" => "renderedtext/developers",
          "Permission" => "write",
          "Members" => "72 members",
          "Created" => "2017-08-01 13:14:40 +0200",
          "Updated" => "2017-08-02 13:14:40 +0200"
        )

        Sem::Commands::Teams::Info.run(["renderedtext/developers"])
      end
    end

    context "team not found" do
      it "displays an error" do
        expect(Sem::UI).to receive(:error).with("Couldn't find that team.")

        Sem::Commands::Teams::Info.run(["renderedtext/nothing"])
      end
    end
  end

end
