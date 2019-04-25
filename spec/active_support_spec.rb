require 'spec_helper'
require 'active_support'
require 'active_record'
require 'action_controller'

RSpec.describe ActiveSupport do
  before do
    ActiveSupport::Dependencies.autoload_paths = Dir["#{__dir__}/muffin_blog/app/*"]
  end

  it 'can search for a file' do
    file = ActiveSupport::Dependencies.search_for_file("application_controller")
    expect(file).to eq "#{__dir__}/muffin_blog/app/controllers/application_controller.rb"
  end

  it 'returns nil if there is an unknown file' do
    file = ActiveSupport::Dependencies.search_for_file("unknown")
    expect(file).to eq nil
  end

  it 'corrects the case of the name' do
    expect(Post.to_s.underscore).to eq "post"
    expect(ApplicationController.to_s.dup.underscore).to eq "application_controller"
  end
end
