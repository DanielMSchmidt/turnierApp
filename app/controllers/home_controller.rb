class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def impressum
  end
end
