class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_clubs

  def get_clubs
    @own_clubs = current_user.clubs
    @clubs = Club.all.delete_if {|club| @own_clubs.include?(club) }
  end
end
