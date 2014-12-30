define do
  name        'serve'
  usage       'serve <port>'
  summary     'Run the Rack Server'
  description 'Serve the API and status page using a Rack webserver.'

  run do |opts, args, cmd|
    require "forgeinator5000/api"
    Forgeinator5000::API.run! :port => args[0], :bind => '0.0.0.0'
  end
end
