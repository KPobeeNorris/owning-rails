require 'spec_helper'

RSpec.describe ActionController do
  class TestController < ActionController::Base
    before_action :callback, only: [:show]
    after_action :callback_after, only: [:show]

    def index
      response << "index"
    end

    def show
      response << "show"
    end

    def redirect
      redirect_to "/"
    end

    private
      def callback
        response << "callback"
      end

      def callback_after
        response << "callback_after"
      end
  end



  it 'can get a response when calling index' do
    thing = TestController.new
    thing.response = []
    thing.process :index
    expect(thing.response).to eq ["index"]
  end

  it 'returns the callback when calling show' do
    subject = TestController.new
    subject.response = []
    subject.process :show
    expect(subject.response).to eq ["callback", "show", "callback_after"]
  end


  class Request
    def params
      { 'id' => 1 }
    end
  end

  it 'works on a real controller' do
    controller = PostsController.new
    controller.request = Request.new
    controller.process :show

    expect(controller.instance_variable_get(:@post)).to eq "something"
  end

  class Response
    attr_accessor :status, :location, :body
  end

  xit 'can redirect to a specific page' do
    controller = TestController.new
    controller.response = Response.new
    controller.process :redirect

    expect(controller.response.status).to eq 302
    expect(controller.response.location).to eq "/"
    expect(controller.response.body).to eq ["You are being redirected"]
  end
end
