require "forgeinator5000/cli"

describe Forgeinator5000::CLI do
  subject do
    described_class.new
  end


  describe "#initialize" do
    it "should configure cri" do
      expect(subject.cri).to be_an_instance_of Cri::Command
    end
  end
end
