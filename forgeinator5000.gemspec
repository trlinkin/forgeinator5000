Gem::Specification.new do |s|
  s.name        = "forgeinator5000"
  s.version     = "1.0.4"
  s.license     = "Apache License, Version 2.0"
  s.summary     = "Your own personal Puppet Forge"
  s.description = "A simple Ruby/Rack-based Puppet Forge API server."
  s.authors     = ["Jordan Olshevski"]
  s.email       = 'jordan@puppetlabs.com'
  s.files       = Dir.glob('**/*')
  s.homepage    = 'https://github.com/jolshevski/forgeinator5000'
  s.executable  = 'forgeinator'

  s.add_development_dependency "rake", "~> 10.4.2"
  s.add_development_dependency "rspec", "~> 3.1.0"
  s.add_development_dependency "rack-test", "~> 0.6.2"

  s.add_runtime_dependency "archive-tar-minitar", "~> 0.5.2"
  s.add_runtime_dependency "git", "~> 1.2.8"
  s.add_runtime_dependency "sinatra", "~> 1.4.5"
  s.add_runtime_dependency "json", "~> 1.8.1"
  s.add_runtime_dependency "thin", "~> 1.6.3"
  s.add_runtime_dependency "cri", "~> 2.6.1"
end
