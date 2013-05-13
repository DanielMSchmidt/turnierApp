class HomeController < ApplicationController
  def index
    checkIfUserIsReadyToStart(current_user) if user_signed_in?
  end

  def admin
    setClubs

    if @user_clubs.empty?
      redirect_to root_path
    else
      @verified_users = @active_club.verified_members
      @unverified_members = @active_club.unverified_members
      @unenrolled_tournaments = @verified_users.collect{|x| x.tournaments.select{|x| !x.enrolled?}}.flatten.sort_by{|e| e.get_date}
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
      redirect_to admin_dashboard_path(club_id: @active_club.id)
    else
      @active_club = @user_clubs.select{|x| x.id == params[:club_id].to_i}.first
    end
  end
end
