require "spec_helper"

RSpec.describe Sem do
  it "has a version number" do
    expect(Sem::VERSION).not_to be nil
  end

  it "hello says hello" do
    expect { Sem.hello }.to_not raise_exception
  end
end
