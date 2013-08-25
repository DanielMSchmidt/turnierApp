# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :setUserModalDataIfLoggedIn

  def after_sign_in_path_for(resource)
    root_path
  end

  def setUserModalDataIfLoggedIn
    setUserModalData if user_signed_in?
  end

  def setUserModalData
    @clubs = Club.all
    @own_clubs = current_user.clubs
    @couple = Couple.new
    @tournament = Tournament.new
  end
end
