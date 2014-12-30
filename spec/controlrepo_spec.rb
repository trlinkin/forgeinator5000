require "forgeinator5000/controlrepo"

describe Forgeinator5000::Controlrepo do
  subject do
    @git = object_double("Git", :clone => nil).as_stubbed_const
    described_class.new("testpath")
  end


  describe "#initialize" do
    it "clones git repository" do
      allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:spawn_puppetfiles)
      allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:purge_tmpdir!)
      subject
      expect(@git).to have_received(:clone).with("testpath", "testpath", {:path=>"/tmp/forgeinator5000"})
    end

    it "purges temporary directory twice" do
      allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:spawn_puppetfiles)
      allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:purge_tmpdir!)
      subject
      expect(subject).to have_received(:purge_tmpdir!).twice
    end

    it "spawns Forgeinator5000::Puppetfile instances" do
      allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:spawn_puppetfiles)
      allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:purge_tmpdir!)
      subject
      expect(subject).to have_received(:spawn_puppetfiles)
    end
  end

  describe "#purge_tmpdir!" do
    context "with configuration set" do
      context "temp directory exists" do
        it "purges directory" do
          allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:spawn_puppetfiles)
          fileutils = object_double("FileUtils", :rmtree => nil, :mkdir => nil).as_stubbed_const
          file = object_double("File", :directory? => true, :basename => nil).as_stubbed_const
          subject.purge_tmpdir!
          expect(fileutils).to have_received(:rmtree).at_least(2).times
        end

        it "creates directory" do
          allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:spawn_puppetfiles)
          fileutils = object_double("FileUtils", :rmtree => nil, :mkdir => nil).as_stubbed_const
          file = object_double("File", :directory? => false, :basename => nil).as_stubbed_const
          subject.purge_tmpdir!
          expect(fileutils).to have_received(:mkdir).at_least(2).times
        end
      end

      context "temp directory does not exist" do
        it "does not purge directory" do
          allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:spawn_puppetfiles)
          fileutils = object_double("FileUtils", :rmtree => nil, :mkdir => nil).as_stubbed_const
          file = object_double("File", :directory? => false, :basename => nil).as_stubbed_const
          subject.purge_tmpdir!
          expect(fileutils).to_not have_received(:rmtree)
        end

        it "creates directory" do
          allow_any_instance_of(Forgeinator5000::Controlrepo).to receive(:spawn_puppetfiles)
          fileutils = object_double("FileUtils", :rmtree => nil, :mkdir => nil).as_stubbed_const
          file = object_double("File", :directory? => false, :basename => nil).as_stubbed_const
          subject.purge_tmpdir!
          expect(fileutils).to have_received(:mkdir).at_least(2).times
        end
      end
    end
  end
end
