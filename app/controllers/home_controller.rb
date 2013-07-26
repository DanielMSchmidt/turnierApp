# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  def index
    checkIfUserIsReadyToStart(current_user) if user_signed_in?
  end

  def admin
    setClubs
    if @user_clubs.empty?
      redirect_to root_path
    else
      @verified_couples = @active_club.verifiedCouples
      @unverified_couples = @active_club.unverifiedCouples
      @unenrolled_tournaments = @verified_couples.collect{|x| x.tournaments.select{|x| !x.enrolled?}}.flatten.sort_by{|e| e.get_date}
    end

    @verified_users = @verified_couples.collect{|c| c.users}.flatten
    @unverified_users = @verified_couples.collect{|c| c.users}.flatten
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


  # Static pages

  def faq
    @active_page = 'faq'
  end

  def impressum
    @active_page = 'impressum'
  end

end
