require 'spec_helper'
require 'muffin_blog/app/models/application_record'
require 'muffin_blog/app/models/post'

describe ActiveRecord do
  it 'initialises a new post' do
    post = Post.new(id: 1, title: "My first post")
    expect(post.id).to eq 1
    expect(post.title).to eq "My first post"
  end
end
