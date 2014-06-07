# -*- encoding : utf-8 -*-
class HomeController < ApplicationController

  def index
    if user_signed_in?
      checkIfUserIsReadyToStart(current_user)
      if Club.ownedBy(current_user).any?
        @admin = true
        setClubs(false)
        setCouplesAndTournaments
      else
        @admin = false
      end
    end

    setLazyloadPaths
  end

  def admin
    setClubs
    if @user_clubs.empty?
      @admin = false
      redirect_to root_path
    else
      @admin = true
      setCouplesAndTournaments
    end

    setLazyloadPaths
  end

  def setCouplesAndTournaments
    @verified_couples = @active_club.verifiedCouples
    @unverified_couples = @active_club.unverifiedCouples
    @unenrolled_tournaments = @verified_couples.collect{|x| x.tournaments.select{|x| !x.enrolled?}}.flatten.sort_by{|e| e.getDate}
    @verifiedUsers = @verified_couples.collect{|c| c.users}.flatten
    @unverifiedUsers = @verified_couples.collect{|c| c.users}.flatten
  end

  def checkIfUserIsReadyToStart(user)
    @has_couple = user.activeCouple.present? && user.activeCouple.isComplete?
    @has_a_club = user.clubs.first.present?
    tournaments_with_missing_data = user.tournaments.collect{|tournament| tournament.behindTime?}
    if tournaments_with_missing_data.nil? || tournaments_with_missing_data.empty?
      @has_missing_data = false
    else
      @has_missing_data = tournaments_with_missing_data.inject{|memo, current| memo || current}
    end
  end

  def setClubs(redirect=true)
    @user_clubs = Club.ownedBy(current_user)
    if @user_clubs.nil?
      @user_clubs = Club.trainedBy(current_user)
      @trainer = true
    else
      @trainer = false
    end

    if params[:club_id].nil?
      @active_club = @user_clubs.first
      redirect_to admin_dashboard_path(club_id: @active_club.id) if redirect
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
