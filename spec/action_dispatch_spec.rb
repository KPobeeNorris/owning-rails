require 'spec_helper'

RSpec.describe ActionDispatch do
  it 'can add a new route' do
    routes = ActionDispatch::Routing::RouteSet.new
    route = routes.add_route "GET", "/posts", "posts", "index"
    expect(route.controller).to eq "posts"
    expect(route.action).to eq "index"
    expect(route.method).to eq "GET"
  end

  it 'finds a route' do
    routes = ActionDispatch::Routing::RouteSet.new
    route = routes.add_route "GET", "/posts", "posts", "index"
    route = routes.add_route "POST", "/posts", "posts", "create"

    request = Rack::Request.new(
      "REQUEST_METHOD" => "POST",
      "PATH_INFO" => "/posts"
    )

    route = routes.find_route(request)

    expect(route.controller).to eq "posts"
    expect(route.action).to eq "create"
    expect(route.method).to eq "POST"
  end

  it 'draws from the routes file' do
    routes = ActionDispatch::Routing::RouteSet.new
    routes.draw do
      get "/hello", to: "hello#index"
      root to: "posts#index"
      resources :posts
    end

    request = Rack::Request.new(
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/posts/new"
    )

    route = routes.find_route(request)

    expect(route.controller).to eq "posts"
    expect(route.action).to eq "new"
    expect(route.method).to eq "GET"
    expect(route.name).to eq "new_post"
  end
end
