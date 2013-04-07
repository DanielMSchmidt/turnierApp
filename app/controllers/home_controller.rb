class HomeController < ApplicationController
  def index
    if user_signed_in?
      checkIfUserIsReadyToStart(current_user)
      setUserModalData
    end
  end

  def impressum
    @active_page = 'impressum'
  end

  def checkIfUserIsReadyToStart(user)
    @has_couple = user.activeCouple.present?
    @has_a_club = user.clubs.first.present?
  end

  def setUserModalData
    @clubs = Club.all
    @couple = Couple.new
  end
end
