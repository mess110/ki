require 'spec_helper'

describe Ki::Middleware::HamlCompiler do
  let(:compiler) { Ki::Middleware::HamlCompiler }

  it 'works' do
    # TODO: find out why twice
    expect_any_instance_of(compiler).to receive(:view_exists?).twice.and_return(true)
    expect(File).to receive(:read).twice.and_return('%p hello')
    get '/existing_haml'
    expect(last_response.body).to eq "<p>hello</p>\n"
  end

  it 'passes to next middleware' do
    expect_any_instance_of(compiler).to receive(:view_exists?).and_return(false)
    get '/inexisting_haml'
    expect(last_response.body).to eq '<h1>404</h1>'
  end
end
