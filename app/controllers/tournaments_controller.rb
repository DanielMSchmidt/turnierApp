# -*- encoding : utf-8 -*-
class TournamentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :setActivePage

  # GET /tournaments/1/edit
  def edit
    @tournament = Tournament.find(params[:id])
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new_for_user(params)

    if @tournament.save
      redirect_to root_path, notice: t('tournament create')
    else
      render :new
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.json
  def update
    @tournament = Tournament.find(params[:id])

    if @tournament.update_attributes(params[:tournament])
      redirect_to root_path, notice: t('club update')
    else
      render :edit
    end
  end

  def set_as_enrolled
    tournament = Tournament.find(params[:id])
    if tournament.update_column(:enrolled, true)
      logger.debug "Tournament Number #{params[:id]} was set as enrolled."
    else
      logger.debug "Tournament Number #{params[:id]} couldn't be set as enrolled."
    end
    redirect_to :back
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to user_tournaments_path(current_user) }
      format.json { head :no_content }
    end
  end

  def of_user
    @user = User.find(params[:id])
    @tournaments = @user.tournaments
  end

  def setActivePage
    @active_page = 'results'
  end
end
