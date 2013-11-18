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
    @tournament = Tournament.newForUser(params)

    if @tournament.valid?
      redirect_to root_path, notice: t('tournament.create.success')
    else
      redirect_to root_path, error: t('tournament.create.fail')
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.json
  def update
    @tournament = Tournament.find(params[:id])

    if @tournament.update_attributes(params[:tournament])
      redirect_to root_path, notice: t('tournament.update.success')
    else
      redirect_to root_path, error: t('tournament.update.fail')
    end
  end

  def setAsEnrolled
    tournament = Tournament.find(params[:id])
    if tournament.update_column(:enrolled, true)
      logger.debug "Tournament Number #{params[:id]} was set as enrolled."
    else
      logger.debug "Tournament Number #{params[:id]} couldn't be set as enrolled."
    end
    redirect_to root_path
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to user_tournaments_path(current_user), success: t('tournament.destroy') }
      format.json { head :no_content }
    end
  end

  def ofUser
    @user = User.find(params[:id])
    @tournaments = @user.tournaments
  end

  def setActivePage
    @active_page = 'results'
  end
end
