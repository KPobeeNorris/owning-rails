require 'spec_helper'

RSpec.describe ActiveRecord do
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

  it 'returns all posts' do
    post = Post.all.first
    expect(post).to be_a_kind_of(Post)
    expect(post.id).to eq 1
    expect(post.title).to eq "Blueberry muffins"
  end

  it 'can execute sql query' do
    rows = Post.connection.execute("SELECT * FROM posts")
    expect(rows).to be_a_kind_of(Array)
    row = rows.first
    expect(row).to be_a_kind_of(Hash)
    expect(row.keys).to eq [:id, :title, :body, :created_at, :updated_at]
  end

  it 'can find a record using where' do
    relation = Post.where("id = 2").where("title IS NOT NULL")
    expect(relation.to_sql).to eq "SELECT * FROM posts WHERE id = 2 AND title IS NOT NULL"
    post = relation.first
    expect(post.id).to eq 2
  end
end
