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

  def setLazyloadPaths
    @paths = [root_path]
    if user_signed_in?
      @paths << user_tournaments_path(current_user)
      @paths << admin_dashboard_path if @user_clubs.any?
    end
    @paths.reject!{|p| p == request.path}
  end
end
