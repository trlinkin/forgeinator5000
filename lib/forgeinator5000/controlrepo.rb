require "rubygems"
require "git"
require "forgeinator5000/puppetfile"

module Forgeinator5000
  class Controlrepo

    attr_reader :puppetfiles

    # path = Git remote URL
    def initialize path
      purge_tmpdir!
      @repo = Git.clone(path, File.basename(path, '.git'), :path => '/tmp/forgeinator5000')
      spawn_puppetfiles
      purge_tmpdir!
    end

    # Purge repo staging directory
    def purge_tmpdir!
      FileUtils.rmtree '/tmp/forgeinator5000' if File.directory?('/tmp/forgeinator5000')
      FileUtils.mkdir '/tmp/forgeinator5000' unless File.directory?('/tmp/forgeinator5000')
    end

    # Traverses each branch of the control repo and
    # returns an instance of Gort::Puppetfile for each
    # encountered Puppetfile
    def spawn_puppetfiles
      @puppetfiles = []
      @repo.branches.remote.each do |branch|
        unless branch.name =~ /->/
          @puppetfiles << Forgeinator5000::Puppetfile.new(@repo.object("#{branch}:Puppetfile").contents)
        end
      end
    end
  end
end
