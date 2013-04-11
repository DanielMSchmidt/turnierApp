class HomeController < ApplicationController
  def index
    checkIfUserIsReadyToStart(current_user) if user_signed_in?
  end

  def impressum
    @active_page = 'impressum'
  end

  def checkIfUserIsReadyToStart(user)
    @has_couple = user.activeCouple.present?
    @has_a_club = user.clubs.first.present?
  end
end
