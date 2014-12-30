require "forgeinator5000/module"

describe Forgeinator5000::Module do
  subject do
    described_class.new 'testmod', '1.2.3'
  end

  describe "#initialize" do
    it "should check to see if module is on disk" do
      allow_any_instance_of(Forgeinator5000::Module).to receive(:ondisk?).and_return(false)
      subject
      expect(subject).to have_received(:ondisk?)
    end

    context "when module is on disk" do
      it "should read module contents" do
        allow_any_instance_of(Forgeinator5000::Module).to receive(:ondisk?).and_return(true)
        allow_any_instance_of(Forgeinator5000::Module).to receive(:read)
        subject
        expect(subject).to have_received(:ondisk?)
        expect(subject).to have_received(:read)
      end
    end
  end

  describe "#download" do
    context "when module is not on disk" do
      it "should write module to disk" do
        file = object_double("File", :open => nil, :exist? => false).as_stubbed_const
        stub = object_double("Test", :code => '200').as_stubbed_const
        allow_any_instance_of(Net::HTTP).to receive(:new)
        allow_any_instance_of(Net::HTTP).to receive(:use_ssl)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(stub)
        subject.download
        expect(file).to have_received(:open).with('/etc/forgeinator5000/modules/testmod-1.2.3.tar.gz', "w")
      end
    end

    context "when module is on disk" do
      it "should not write module to disk" do
        allow_any_instance_of(Forgeinator5000::Module).to receive(:ondisk?).and_return(true)
        allow_any_instance_of(Forgeinator5000::Module).to receive(:read)
        file = object_double("File", :open => nil, :exist? => false).as_stubbed_const
        stub = object_double("Test", :code => '200').as_stubbed_const
        allow_any_instance_of(Net::HTTP).to receive(:new)
        allow_any_instance_of(Net::HTTP).to receive(:use_ssl)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(stub)
        subject.download
        expect(file).to_not have_received(:open).with('/etc/forgeinator5000/modules/testmod-1.2.3.tar.gz', "w")
      end
    end

    context "when forge api responds with http 500" do
      it "should write module to disk" do
        file = object_double("File", :open => nil, :exist? => false).as_stubbed_const
        stub = object_double("Test", :code => '500').as_stubbed_const
        allow_any_instance_of(Net::HTTP).to receive(:new)
        allow_any_instance_of(Net::HTTP).to receive(:use_ssl)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(stub)
        expect{subject.download}.to raise_error RuntimeError
      end
    end
  end

  describe "#destroy" do
    it "should destroy module" do
      stub = object_double("File", :delete => nil, :exist? => false).as_stubbed_const
      subject.destroy
      expect(stub).to have_received(:delete).with('/etc/forgeinator5000/modules/testmod-1.2.3.tar.gz')
    end
  end

  describe "#read" do
    it "should load module from archive" do
      path = File.expand_path("../fixtures/testuser-testmod-1.2.3.tar.gz", __FILE__)
      allow_any_instance_of(Forgeinator5000::Module).to receive(:disk_path).and_return(path)
      subject
      expect(subject['summary']).to eq('test summary')
      expect(subject['name']).to eq('testuser-testmod')
    end

    it "should generate archive checksum" do
      path = File.expand_path("../fixtures/testuser-testmod-1.2.3.tar.gz", __FILE__)
      allow_any_instance_of(Forgeinator5000::Module).to receive(:disk_path).and_return(path)
      subject
      expect(subject['file_md5']).to eq('5e09bfcec52d35550d6ba2f636a55265')
    end
  end

  describe "#[]" do
    it "should return the correct value" do
      path = File.expand_path("../fixtures/testuser-testmod-1.2.3.tar.gz", __FILE__)
      allow_any_instance_of(Forgeinator5000::Module).to receive(:disk_path).and_return(path)
      subject
      expect(subject['name']).to eq('testuser-testmod')
    end
  end

  describe "#ondisk?" do
    it "should return true if module is on disk" do
      stub = object_double("File", :exist? => false).as_stubbed_const
      subject.ondisk?
      expect(stub).to have_received(:exist?).with('/etc/forgeinator5000/modules/testmod-1.2.3.tar.gz').twice
    end
  end

  describe "#disk_path" do
    it "should return the path to this module on disk" do
      expect(subject.disk_path).to eq('/etc/forgeinator5000/modules/testmod-1.2.3.tar.gz')
    end
  end

  describe "#remote_path" do
    it "should return the path to this module on disk" do
      expect(subject.remote_path).to eq('https://forgeapi.puppetlabs.com/v3/files/testmod-1.2.3.tar.gz')
    end
  end

  describe "#all" do
    context "when not unarchiving modules" do
      it "should return a hash for each module" do
        mods = ['modules/user-mod-1.2.3.tar.gz', 'modules/user2-mod2-1.2.3.tar.gz']
        object_double("Dir", :glob => mods).as_stubbed_const
        expect(Forgeinator5000::Module.all(false)).to eq([
          {"name"=>"user-mod", "version"=>"1.2.3"},
          {"name"=>"user2-mod2", "version"=>"1.2.3"}])
      end
    end
  end
end
