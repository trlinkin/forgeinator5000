require "forgeinator5000/api"

require "rack/test"
module RSpecMixin
  include Rack::Test::Methods
  def app() Forgeinator5000::API end
end

RSpec.configure { |c| c.include RSpecMixin }

testmodules = [
  { 'name' => 'testmod1', 'version' => '1.2.3' , 'project_page' => 'test', 'summary' => 'testsummary' },
  { 'name' => 'testmod2', 'version' => '9.9.99', 'project_page' => 'test', 'summary' => 'testsummary' },
]

describe "/" do
  it "should return http status 200" do
    get '/'
    expect(last_response.status).to eq(200)
  end

  it "should contain super awesome name" do
    get '/'
    expect(last_response.body).to include('FORGEINATOR 5000')
  end

  it "should contain a line for each module in the inventory" do
    object_double("Forgeinator5000::Module", :all => testmodules).as_stubbed_const
    get '/'
    expect(last_response.body).to include('testmod1').and include('testmod2')
  end
end

describe "/v3/modules" do
  it "should not return results if none are found" do
    get '/v3/modules', params={ 'query' => 'impossiblequery' }
    expect(last_response.body).to include("pagination").and include("results")
  end

  it "should return results" do
    object_double("Forgeinator5000::Module", :all => testmodules).as_stubbed_const
    get '/v3/modules', params={ 'query' => 'test' }
    expect(last_response.body).to include("testmod1").and include("testmod2")
  end
end

describe "/v3/releases" do
  it "should not return results if none are found" do
    get '/v3/releases', params={ 'query' => 'impossiblequery' }
    expect(last_response.body).to include("pagination").and include("results")
  end

  it "should return the correct module" do
    object_double("Forgeinator5000::Module", :all => testmodules).as_stubbed_const
    get '/v3/releases', params={ 'module' => 'testmod1' }
    expect(last_response.body).to include('"name":"testmod1"').and include('"file_uri":"/v3/files/testmod1-1.2.3.tar.gz"')
  end
end
