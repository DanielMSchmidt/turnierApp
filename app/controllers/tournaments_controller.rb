class TournamentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :setActivePage
  before_filter :setOrganisingTournaments, only: [:show, :index, :of_user]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.includes(:user).all if current_user.email == "daniel.maximilian@gmx.net" #todo: irgendwann durch admin ersetzen
    @tournaments ||= []

    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tournaments }
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tournament }
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.json
  def new
    @active_page = 'add_result'
    @tournament = Tournament.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tournament }
    end
  end

  # GET /tournaments/1/edit
  def edit
    @tournament = Tournament.find(params[:id])
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(enhanced_informations)

    if @tournament.save
      redirect_to @tournament, notice: 'Tournament was successfully created.'
    else
      render :new
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.json
  def update
    @tournament = Tournament.find(params[:id])

    if @tournament.update_attributes(params[:tournament])
      redirect_to @tournament, notice: 'Tournament was successfully updated.'
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
      format.html { redirect_to tournaments_url }
      format.json { head :no_content }
    end
  end

  def of_user
    @user = User.find(params[:id])
    @tournaments = @user.tournaments
  end

  def enhanced_informations
    logger.debug "enhance information for tournament number #{params[:tournament][:number]}"

    new_informations = Tournament.find_by_number(params[:tournament][:number])
    unless new_informations.nil?
      logger.debug "Enhanced informations"
      return params[:tournament].merge!(new_informations)
    else
      logger.debug "Didn't enhanced informations"
      return params[:tournament]
    end
  end

  def setActivePage
    @active_page = 'results'
  end

  def setOrganisingTournaments
    @organisingTournaments = current_user.getOrganisedTournaments unless current_user.nil?
  end
end
