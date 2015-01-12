require "forgeinator5000/module"
require "forgeinator5000/controlrepo"

module Forgeinator5000
  class Updator

    attr_accessor :modules, :repo

    def initialize repo=nil
      @repo = repo
    end

    def load_config
      @repo = File.read('/etc/forgeinator5000/repo').chomp if File.exist?('/etc/forgeinator5000/repo')
    end

    def instantiate_modules
      @modules.map! do |mod|
        puts 'found a module'
        Forgeinator5000::Module.new(mod['name'], mod['version'])
      end
    end

    def download_modules
      @modules.each do |mod|
        puts 'downloading a module'
        begin
        mod.download
        rescue Exception => e
          puts e
        end
      end
    end

    def get_modules
      raise "You must configure a control repository before attempting to update inventory" unless @repo
      @modules = Forgeinator5000::Controlrepo.new(@repo).puppetfiles.map {|pf| pf.modules }
      puts Forgeinator5000::Controlrepo.new(@repo)
      @modules.flatten!(1)
      @modules.uniq!
    end
  end
end
