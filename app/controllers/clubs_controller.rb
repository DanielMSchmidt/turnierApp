# -*- encoding : utf-8 -*-
class ClubsController < ApplicationController

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
      @club.memberships.create!(couple_id: current_user.activeCouple.id, verified: true)
      redirect_to root_path, notice: t('club.create')
    else
      render :new
    end
  end

  # PUT /clubs/1
  # PUT /clubs/1.json
  def update
    @club = Club.find(params[:id])

    if @club.update_attributes(params[:club])
      redirect_to root_path, notice: t('club.update')
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

  def printTournaments
    @club = Club.find(params[:club_id].to_i)
    @from = params[:from].to_date
    @to = params[:to].to_date

    all_tournaments = Tournament.where(date: (@from..@to)).select{|t| t.belongs_to_club(@club.id)}
    @upcoming = (params[:tournament_type] == "upcoming")


    if @upcoming
      @tournaments = all_tournaments.select{|t| t.upcoming?}
    else
      @tournaments = all_tournaments.reject{|t| t.upcoming?}
    end

    render :pdf => "Turniere des #{@club.name}, #{@from} - #{@to}",
           :show_as_html => false
  end

  def transferOwnership
    @club = Club.find(params[:club_id])
    new_user = User.find(params[:user_id])
    @club.transfer_to(new_user)
    logger.debug "User #{current_user.id} transfered ownership of #{@club.id} to #{new_user.id}"
    redirect_to @club, notice: t("club ownership transfer")
  end
end
