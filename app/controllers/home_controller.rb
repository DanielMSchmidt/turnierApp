class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def impressum
    @active_page = 'impressum'
  end
end
