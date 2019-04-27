require 'spec_helper'

RSpec.describe ActionView do
  it 'can render a template' do
    template = ActionView::Template.new("<p>Hello<p>", "test_render_template")
    context = ActionView::Base.new

    expect(template.render(context)).to eq "<p>Hello<p>"
  end

  it 'can render a template with variables' do
    template = ActionView::Template.new("<p><%= @var %><p>", "test_render_with_vars")
    context = ActionView::Base.new var: "var value"

    expect(template.render(context)).to eq "<p>var value<p>"
  end

  it 'can render with a yield' do
    template = ActionView::Template.new("<p><%= yield %><p>", "test_render_with_yield")
    context = ActionView::Base.new

    expect(template.render(context) { "yielded content"}).to eq "<p>yielded content<p>"
  end

  it 'can render with a helper' do
    template = ActionView::Template.new("<%= link_to 'title', '/url' %>", "test_render_with_helper")
    context = ActionView::Base.new

    expect(template.render(context)).to eq "<a href=\"/url\">title</a>"
  end

  it 'can find a template' do
    file = "#{__dir__}/muffin_blog/app/views/posts/index.html.erb"
    template1 = ActionView::Template.find(file)
    template2 = ActionView::Template.find(file)

    expect(template2).to eq template1
  end

  class TestController < ActionController::Base
    def index
      @var = "var value"
    end
  end

  it 'assigns a view' do
    controller = TestController.new
    controller.index

    expect(controller.view_assigns).to eq ( { "var" => "var value"} )
  end

  it 'tests the rendering the show view' do
    request = Rack::MockRequest.new(Rails.application)
    response = request.get("/posts/show?id=1")

    expect(response.body).to include("<h1>Blueberry muffins</h1>")
  end

  it 'tests the rendering the index view' do
    request = Rack::MockRequest.new(Rails.application)
    response = request.get("/posts")

    expect(response.body).to include("<h1>Muffin Blog<h1>")
  end
end
