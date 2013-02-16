require 'spec_helper'
require 'capybara/rails'

describe "Tournament" do
  before(:each) do
    @user ||= FactoryGirl.create(:user)
    @club ||= FactoryGirl.create(:club)
    FactoryGirl.create(:membership)
  end
end