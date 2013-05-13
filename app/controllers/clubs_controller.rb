# -*- encoding : utf-8 -*-
class ClubsController < ApplicationController
  # GET /clubs
  # GET /clubs.json
  before_filter :setClubsAsActive

  def index
    @clubs = Club.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clubs }
    end
  end

  # GET /clubs/1
  # GET /clubs/1.json
  def show
    @club = Club.find(params[:id])

    return redirect_to(clubs_path) if !@club.is_verified_member(current_user)

    @verified_users = @club.verified_members
    @unverified_members = @club.unverified_members

    @unenrolled_tournaments = @verified_users.collect{|x| x.tournaments.select{|x| !x.enrolled?}}.flatten.sort_by{|e| e.get_date}


    if @club.user_id == current_user.id
      @organisingTournaments = @unenrolled_tournaments
    else
      @organisingTournaments = []
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @club }
    end
  end

  # GET /clubs/new
  # GET /clubs/new.json
  def new
    @club = Club.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @club }
    end
  end

  # GET /clubs/1/edit
  def edit
    @club = Club.find(params[:id])
  end

  # POST /clubs
  # POST /clubs.json
  def create
    @club = Club.new(params[:club])
    @club.user = current_user


    if @club.save
      @club.memberships.create!(user_id: current_user)
      redirect_to @club, notice: t('club create')
    else
      render :new
    end
  end

  # PUT /clubs/1
  # PUT /clubs/1.json
  def update
    @club = Club.find(params[:id])

    if @club.update_attributes(params[:club])
      redirect_to @club, notice: t('club update')
    else
      render :edit
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def transfer_ownership
    @club = Club.find(params[:club_id])
    new_user = User.find(params[:user_id])
    @club.transfer_to(new_user)
    logger.debug "User #{current_user.id} transfered ownership of #{@club.id} to #{new_user.id}"
    redirect_to @club
  end

  def setClubsAsActive
    @active_page = 'clubs'
  end
end
