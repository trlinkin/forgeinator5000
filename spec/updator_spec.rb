require "forgeinator5000/updator"

describe Forgeinator5000::Updator do
  subject do
    described_class.new
  end

  describe "#initialize" do
    context "when given a single argument" do
      it "should set the repo path" do
        expect(described_class.new("testrepo").repo).to eq("testrepo")
      end
    end

    context "when not given a single argument" do
      it "should set the repo path to nil" do
        expect(described_class.new.repo).to eq(nil)
      end
    end
  end

  describe "#load_config" do
    context "when configuration file exists" do
      it "should load configuration" do
        file = object_double("File", :read => 'test', :exist? => true).as_stubbed_const
        subject.load_config
        expect(file).to have_received(:read)
      end
    end

    context "when configuration file does not exist" do
      it "should not load configuration" do
        file = object_double("File", :read => nil, :exist? => false).as_stubbed_const
        subject.load_config
        expect(file).to_not have_received(:read)
      end
    end
  end

  describe "#instantiate_modules" do
    context "when modules have been loaded" do
      it "should instantiate a module object for each module reference" do
        mod = object_double("Forgeinator5000::Module", :new => nil).as_stubbed_const
        inst = described_class.new
        inst.modules = [ {'name' => 'testmod1', 'version' => '1.2.3'}, {'name' => 'testmod2', 'version' => '2.2.3'} ]
        inst.instantiate_modules
        expect(mod).to have_received(:new).twice
      end
      it "should store each instance in the modules array" do
        inst = described_class.new
        inst.modules = [ {'name' => 'testmod1', 'version' => '1.2.3'}, {'name' => 'testmod2', 'version' => '2.2.3'} ]
        inst.instantiate_modules.each do |mod|
          expect(mod).to be_instance_of Forgeinator5000::Module
        end
      end
    end

    describe "#download_modules" do
      context "when modules have been loaded" do
        it "should download each module" do
          inst = described_class.new
          mod = instance_double("Forgeinator5000::Module", :download => nil, :[] => nil)
          inst.modules = [ mod ]
          inst.download_modules
          expect(mod).to have_received(:download)
        end
      end
    end
  end
end
