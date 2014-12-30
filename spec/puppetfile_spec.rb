require "forgeinator5000/puppetfile"

describe Forgeinator5000::Puppetfile do
  subject do
    described_class.new("")
  end

  describe "#initialize" do
    context "when given a valid puppetfile" do
      pf = """
        mod 'testmod', '1.2.3'
        mod 'testuser-testmod', '2.2.3'
        mod 'testuser2/testmod2', '3.2.3'
      """
      it "should not raise an error" do
        expect{described_class.new pf}.to_not raise_error
      end
    end

    context "when given an invalid puppetfile" do
      pf = """
        mod 'testmod', '1.2.3'
        mod 'testuser-testmod', '2.2.3'
        mod 'testuser2/testmod2', '3.2.3'
        not a module
      """
      it "should not raise an error" do
        expect{described_class.new pf}.to raise_error SyntaxError
      end
    end
  end

  describe "#add_module" do
    context "with a dash delimiter and version" do
      it "adds a hash to the modules array" do
        subject.add_module 'testuser-testmod', '1.2.3'
        expect(subject.modules).to include({ 'name' => 'testuser-testmod', 'version' => '1.2.3' })
      end
    end

    context "with a slash delimiter and version" do
      it "changes the delimiter to a dash and adds a hash to the modules array" do
        subject.add_module 'testuser/testmod', '1.2.3'
        expect(subject.modules).to include({ 'name' => 'testuser-testmod', 'version' => '1.2.3' })
      end
    end

    context "without a version" do
      it "logs a warning" do
        logger = object_double("Log", :warn => nil).as_stubbed_const
        subject.add_module 'testuser/testmod'
        expect(logger).to have_received(:warn).with("Skipping module testuser/testmod because no version was specified")
      end
    end

    context "without a version" do
      it "logs a warning" do
        logger = object_double("Log", :warn => nil).as_stubbed_const
        subject.add_module 'testuser/testmod'
        expect(logger).to have_received(:warn).with("Skipping module testuser/testmod because no version was specified")
      end
    end

    context "with an invalid version" do
      it "logs a warning" do
        logger = object_double("Log", :warn => nil).as_stubbed_const
        subject.add_module 'testuser/testmod', '1.2'
        expect(logger).to have_received(:warn).with("Skipping module testuser/testmod because it doesn't appear to be sourced from the forge")
      end
    end

    context "with an array as second param" do
      it "logs a warning" do
        logger = object_double("Log", :warn => nil).as_stubbed_const
        subject.add_module 'testuser/testmod', []
        expect(logger).to have_received(:warn).with("Skipping module testuser/testmod because it doesn't appear to be sourced from the forge")
      end
    end

    context "with a hash as second param" do
      it "logs a warning" do
        logger = object_double("Log", :warn => nil).as_stubbed_const
        subject.add_module 'testuser/testmod', {}
        expect(logger).to have_received(:warn).with("Skipping module testuser/testmod because it doesn't appear to be sourced from the forge")
      end
    end
  end

  describe "#modules" do
    context "after adding a single valid module" do
      before { subject.add_module 'testuser-testmod', '1.2.3' }
      it "returns an array containing only the module" do
        expect(subject.modules).to match [{'name' => 'testuser-testmod', 'version' => '1.2.3'}]
      end
    end

    context "after adding three valid modules" do
      it "returns an array containing the three modules" do
        subject.add_module 'testuser-testmod', '1.2.3'
        subject.add_module 'testuser-testmod2', '1.3.3'
        subject.add_module 'testuser-testmod3', '1.3.4'
        expect(subject.modules).to match [
          {'name' => 'testuser-testmod', 'version' => '1.2.3'},
          {'name' => 'testuser-testmod2', 'version' => '1.3.3'},
          {'name' => 'testuser-testmod3', 'version' => '1.3.4'},
        ]
      end
    end

    context "after adding three matching modules" do
      it "returns an array without duplicates" do
        subject.add_module 'testuser-testmod', '1.2.3'
        subject.add_module 'testuser-testmod', '1.2.3'
        subject.add_module 'testuser-testmod', '1.2.3'
        expect(subject.modules).to match [{'name' => 'testuser-testmod', 'version' => '1.2.3'}]
      end
    end
  end
end


describe Forgeinator5000::Puppetfile::DSL do

  describe "#mod" do
    context "parsing a valid module reference" do
      it "adds a module" do
        pf = instance_double("Gort::Puppetfile", :add_module => nil)
        dsl = described_class.new(pf)
        dsl.mod "testuser-testmod", "1.2.3"
        expect(pf).to have_received(:add_module).with("testuser-testmod", "1.2.3")
      end
    end

    context "parsing a module reference with no param" do
      it "adds a module" do
        pf = instance_double("Gort::Puppetfile", :add_module => nil)
        dsl = described_class.new(pf)
        dsl.mod "testuser-testmod"
        expect(pf).to have_received(:add_module).with("testuser-testmod", nil)
      end
    end
  end
end
