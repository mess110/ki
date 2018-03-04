# frozen_string_literal: true

require 'spec_helper'

describe Ki::BaseRequest do
  let(:req) { Ki::BaseRequest }

  it 'knows if current path is root' do
    expect(req.new({ 'PATH_INFO' => '/' })).to be_root
    expect(req.new({ 'PATH_INFO' => '/foo' })).to_not be_root
  end

  it 'coverts path to class' do
    class Foo < Ki::Model; end
    class Bar < Ki::Model; end
    class FooBar < Ki::Model; end

    expect(req.new({ 'PATH_INFO' => '' }).to_ki_model_class).to be nil
    expect(req.new({ 'PATH_INFO' => '/' }).to_ki_model_class).to be nil
    expect(req.new({ 'PATH_INFO' => 'foo' }).to_ki_model_class).to be Foo
    expect(req.new({ 'PATH_INFO' => '/foo' }).to_ki_model_class).to be Foo
    expect(req.new({ 'PATH_INFO' => '/Foo.json' }).to_ki_model_class).to be Foo
    expect(req.new({ 'PATH_INFO' => '/bar.json' }).to_ki_model_class).to be Bar
    expect(req.new({ 'PATH_INFO' => '/Foo/bar.json' }).to_ki_model_class).to be nil
    expect(req.new({ 'PATH_INFO' => '/Foo/bar' }).to_ki_model_class).to be nil
    expect(req.new({ 'PATH_INFO' => '/Foo_bar' }).to_ki_model_class).to be FooBar
    expect(req.new({ 'PATH_INFO' => '/foo_bar' }).to_ki_model_class).to be FooBar
    expect(req.new({ 'PATH_INFO' => '/foo_bar.json' }).to_ki_model_class).to be FooBar
  end

  it 'converts verb to action' do
    expect(req.new({ 'REQUEST_METHOD' => 'GET' }).to_action).to be :find
    expect(req.new({ 'REQUEST_METHOD' => 'POST' }).to_action).to be :create
    expect(req.new({ 'REQUEST_METHOD' => 'PUT' }).to_action).to be :update
    expect(req.new({ 'REQUEST_METHOD' => 'DELETE' }).to_action).to be :delete
    expect(req.new({ 'REQUEST_METHOD' => 'SEARCH' }).to_action).to be :find
  end

  context 'json' do
    it 'considers application/json content type as a json request' do
      expect(req.new({ 'CONTENT_TYPE' => 'application/xml' })).to_not be_json
      expect(req.new({})).to_not be_json
      expect(req.new({ 'CONTENT_TYPE' => 'application/json' })).to be_json
    end

    it 'considers .json url format as a json request' do
      expect(req.new({ 'PATH_INFO' => '/foo' })).to_not be_json
      expect(req.new({ 'PATH_INFO' => '/foo.json' })).to be_json
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
