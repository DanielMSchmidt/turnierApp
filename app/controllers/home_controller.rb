class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def contact
  end

  def impressum
  end
end
