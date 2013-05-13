class HomeController < ApplicationController
  def index
    checkIfUserIsReadyToStart(current_user) if user_signed_in?
  end

  def admin
    setClubs

    if @user_clubs.empty?
      redirect_to root_path
    else
    end
  end

  def impressum
    @active_page = 'impressum'
  end

  def checkIfUserIsReadyToStart(user)
    @has_couple = user.activeCouple.present?
    @has_a_club = user.clubs.first.present?
    tournaments_with_missing_data = user.tournaments.collect{|tournament| tournament.behind_time?}
    if tournaments_with_missing_data.nil? || tournaments_with_missing_data.empty?
      @has_missing_data = false
    else
      @has_missing_data = tournaments_with_missing_data.inject{|memo, current| memo || current}
    end
  end

  def setClubs
    @user_clubs = Club.owned_by(current_user)
    if params[:club_id].nil?
      @active_club = @user_clubs.first
    else
      @active_club = @user_clubs.select{|x| x.id == params[:club_id].to_i}.first
    end
  end
end
