define do
  name        'update'
  usage       'update <controlrepo>'
  summary     'Download modules referenced by an r10k control repository'
  description 'Clones the control repository and ensures that all referenced modules are available in the forgeinator.'

  run do |opts, args, cmd|
    repo = args[0] if args[0]

    require "forgeinator5000/updator"
    begin
      puts "running"
      updator = Forgeinator5000::Updator.new repo
      updator.load_config unless repo
      updator.get_modules
      updator.instantiate_modules
      updator.download_modules
    rescue Exception => e
      puts e.message
    end
  end
end
