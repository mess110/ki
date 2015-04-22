require 'spec_helper'

describe Ki::Middleware::HamlCompiler do
  let(:compiler) { Ki::Middleware::HamlCompiler }

  it 'works' do
    compiler.any_instance.stub(:view_exists?).and_return(true)
    File.stub(:read).and_return('%p hello')
    get '/existing_haml'
    expect(last_response.body).to eq "<p>hello</p>\n"
  end

  it 'passes to next middleware' do
    compiler.any_instance.stub(:view_exists?).and_return(false)
    get '/inexisting_haml'
    expect(last_response.body).to eq '<h1>404</h1>'
  end
end
