module Forgeinator5000
  class Puppetfile

    # Hand me a string containing the contents of a Puppetfile
    def initialize file
      @modules = []
      dsl = Forgeinator5000::Puppetfile::DSL.new(self)
      dsl.instance_eval(file)
    end

    # Fired when a module is found in the Puppetfile
    def add_module name, args=nil
      case args
      when /\d.\d.\d/
        @modules << { 'name' => name.gsub('/', '-'), 'version' => args }
      when nil
        puts "Skipping module #{name} because no version was specified"
      else
        puts "Skipping module #{name} because it doesn't appear to be sourced from the forge"
      end
    end

    # Return modules
    def modules
      @modules.uniq
    end
  end


  class Forgeinator5000::Puppetfile::DSL
    def initialize(pf)
      @pf = pf
    end

    def mod(name, args = nil)
      @pf.add_module(name, args)
    end
  end
end

