require "cri"

module Forgeinator5000
  class CLI

    attr :cri

    def initialize
      @cri = Cri::Command.define do
        name        'Forgeinator5000'
        usage       'forgeinator <subcommand>'
        summary     'Your own personal Puppet Forge.'
        description 'Serve Puppet modules using the Puppet Forge API.'

        run do |opts, args, cmd|
          puts cmd.help
        end
      end

      # Load subcommands
      Dir.glob("#{File.expand_path("../cli", __FILE__)}/*.rb").each do |cmd|
        cri_cmd = Cri::Command.instance_eval(File.read(cmd))
        @cri.add_command(cri_cmd)
      end
    end
  end
end
