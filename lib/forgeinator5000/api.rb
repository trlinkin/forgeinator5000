require "rubygems"
require "sinatra"
require "json"
require "forgeinator5000/module"
require "forgeinator5000/controlrepo"

module Forgeinator5000
  class API < Sinatra::Base

    configure do
      enable :logging
    end

    get '/' do
      erb :landing
    end

    get '/v3/files/:file' do
      send_file "/etc/forgeinator5000/modules/#{params[:file]}"
    end

    get '/v3/modules' do
      results = []
      Forgeinator5000::Module.all.select {|mod| mod['name'].include? params[:query] or mod['summary'].include? params[:query] }.each do |mod|
        results << {
          'author'          => mod['name'].split('-')[0],
          'name'            => mod['name'].split('-')[1],
          'homepage_url'    => mod['project_page'],
          'owner'           => {
            'username'      => mod['name'].split('-')[0]},
          'current_release' => {
              'tags'        => ['FORGEINATOR5000'],
              'version'     => mod['version'],
              'metadata'    => {
                'summary'   => mod['summary']
              }
            },
        }
      end
      results.uniq!
      output = {
        'pagination' => {},
        'results' => results,
      }
      content_type :json
      output.to_json
    end

    get '/v3/releases' do
      results = []
      Forgeinator5000::Module.all.select {|mod| mod['name'] == params[:module] }.each do |mod|
        results << {
          "metadata" => {
            "name"         => mod['name'],
            "version"      => mod['version'],
            "dependencies" => mod['dependencies']
          },
          "file_uri"       => "/v3/files/#{mod['name']}-#{mod['version']}.tar.gz",
          "file_md5"       => mod['file_md5'],
        }
      end
      output = {
        "pagination" => {},
        "results"    => results,
      }
      content_type :json
      output.to_json
    end
  end
end
