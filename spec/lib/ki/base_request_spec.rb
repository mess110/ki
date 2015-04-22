require 'spec_helper'

describe Ki::BaseRequest do
  let(:req) { Ki::BaseRequest }

  it 'knows if current path is root' do
    req.new({ 'PATH_INFO' => '/' }).root?.should be_true
    req.new({ 'PATH_INFO' => '/foo' }).root?.should be_false
  end

  it 'coverts path to class' do
    class Foo < Ki::Model; end
    class Bar < Ki::Model; end
    class FooBar < Ki::Model; end

    req.new({ 'PATH_INFO' => '' }).to_ki_model_class.should be nil
    req.new({ 'PATH_INFO' => '/' }).to_ki_model_class.should be nil
    req.new({ 'PATH_INFO' => 'foo' }).to_ki_model_class.should be Foo
    req.new({ 'PATH_INFO' => '/foo' }).to_ki_model_class.should be Foo
    req.new({ 'PATH_INFO' => '/Foo.json' }).to_ki_model_class.should be Foo
    req.new({ 'PATH_INFO' => '/bar.json' }).to_ki_model_class.should be Bar
    req.new({ 'PATH_INFO' => '/Foo/bar.json' }).to_ki_model_class.should be nil
    req.new({ 'PATH_INFO' => '/Foo/bar' }).to_ki_model_class.should be nil
    req.new({ 'PATH_INFO' => '/Foo_bar' }).to_ki_model_class.should be FooBar
    req.new({ 'PATH_INFO' => '/foo_bar' }).to_ki_model_class.should be FooBar
    req.new({ 'PATH_INFO' => '/foo_bar.json' }).to_ki_model_class.should be FooBar
  end

  it 'converts verb to action' do
    req.new({ 'REQUEST_METHOD' => 'GET' }).to_action.should be :find
    req.new({ 'REQUEST_METHOD' => 'POST' }).to_action.should be :create
    req.new({ 'REQUEST_METHOD' => 'PUT' }).to_action.should be :update
    req.new({ 'REQUEST_METHOD' => 'DELETE' }).to_action.should be :delete
    req.new({ 'REQUEST_METHOD' => 'SEARCH' }).to_action.should be :find
  end

  context 'json' do
    it 'considers application/json content type as a json request' do
      req.new({ 'CONTENT_TYPE' => 'application/xml' }).json?.should be_false
      req.new({}).json?.should be_false
      req.new({ 'CONTENT_TYPE' => 'application/json' }).json?.should be_true
    end

    it 'considers .json url format as a json request' do
      req.new({ 'PATH_INFO' => '/foo' }).json?.should be_false
      req.new({ 'PATH_INFO' => '/foo.json' }).json?.should be_true
    end

    # context 'params' do
    #   it 'handles get with no params' do
    #     asd = req.new({
    #       'PATH_INFO' => "/foo.json",
    #       'QUERY_STRING' => '',
    #       'REQUEST_METHOD' => 'GET',
    #       'rack.input' => ''
    #     })
    #     asd.params.should be {}
    #   end

    #   it 'handles query params' do
    #     asd = req.new({
    #       'PATH_INFO' => "/foo.json",
    #       'QUERY_STRING' => 'foo=bar&cez[]=dar&cez[]=asd',
    #       'REQUEST_METHOD' => 'GET',
    #       'rack.input' => ''
    #     })
    #     asd.params.should be {'foo' => 'bar', 'cez' => ['dar', 'asd']}
    #   end

    #   it 'handles both query and body params' do
    #     # asd = req.new({
    #     #   'PATH_INFO' => "/foo.json",
    #     #   'QUERY_STRING' => 'foo=bar&cez[]=dar&cez[]=asd',
    #     #   'REQUEST_METHOD' => 'POST',
    #     #   'rack.input' => '{"bar":"foo"}'
    #     # })

    #     asd = StringIO.new
    #     asd << '{"bar":"foo"}'

    #     env = Rack::MockRequest.env_for('foo.json', {
    #       'REQUEST_METHOD' => 'POST',
    #       'QUERY_STRING' => 'foo=bar&cez[]=dar&cez[]=asd',
    #       :input => asd
    #     })
    #     asd = req.new(env)
    #     # p asd.body.read
    #     # Foo.new(asd)
    #   end
    # end
  end
end
