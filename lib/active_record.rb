require "active_record/connection_adapter"
require 'byebug'

module ActiveRecord
  class Base
    def self.abstract_class=(value)
      # Not implemented
    end
   def initialize(attributes = {})
     @attributes = attributes
   end 

   def id
     @attributes[:id]
   end

   def title
     @attributes[:title]
   end

   def self.find(id)
     attributes = connection.execute("SELECT * FROM posts WHERE id = #{id.to_i}").first
     new(attributes)
   end

   def self.all
     posts = connection.execute("SELECT * FROM posts")
     
     posts.map{|post|  new(post)}
   end

   def self.establish_connection(options)
      @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
   end

   def self.connection
      @@connection
   end  
  end
end