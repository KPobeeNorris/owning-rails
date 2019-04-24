require 'spec_helper'
require 'active_record'
require 'muffin_blog/app/models/application_record'
require 'muffin_blog/app/models/post'

RSpec.describe ActiveRecord do

  before do
    Post.establish_connection(
      database: "#{__dir__}/muffin_blog/db/development.sqlite3")
  end

  it 'initialises a new post' do
    post = Post.new(id: 1, title: "My first post")
    expect(post.id).to eq 1
    expect(post.title).to eq "My first post"
  end

  it 'finds a post' do
    post = Post.find(1)
    expect(post).to be_a_kind_of(Post)
    expect(post.id).to eq 1
    expect(post.title).to eq "Blueberry muffins"
  end

  it 'can execute sql' do
    rows = Post.connection.execute("SELECT * FROM posts")
    expect(rows).to be_a_kind_of(Array)
    row = rows.first
    expect(row).to be_a_kind_of(Hash)
    expect(row.keys).to eq [:id, :title, :body, :created_at, :updated_at]
  end
end
