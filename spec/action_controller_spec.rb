require 'spec_helper'


RSpec.describe ActionController do
  class TestController < ActionController::Base
    before_action :callback, only: [:show]

    def index
      response << "index"
    end

    def show
      response << "show"
    end

    private
      def callback
        response << "callback"
      end
  end


  subject { TestController.new }


  it 'can get a response when calling index' do
    subject.response = []
    subject.process :index
    expect(subject.response).to eq ["index"]
  end

  it 'returns the callback when calling show' do
    subject.response = []
    subject.process :show
    expect(subject.response).to eq ["callback", "show"]
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
  end
end
