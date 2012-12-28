class TournamentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :enhance_informations, only: [:create]
  before_filter :setActivePage

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.includes(:user).all
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
    @tournament = Tournament.new(@all_params)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render json: @tournament, status: :created, location: @tournament }
      else
        format.html { render action: "new" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.json
  def update
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
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

  def enhance_informations
    new_informations = find_by_number(params[:tournament][:number])
    unless new_informations.nil?
      logger.debug "Enhanced informations"
      @all_params = params[:tournament].merge!(new_informations)
    else
      logger.debug "Didn't enhanced informations"
      @all_params = params[:tournament]
    end
  end

  def find_by_number(number)
    return nil unless number
    agent = Mechanize.new
    agent.get("http://appsrv.tanzsport.de/td/db/turnier/einzel/suche")
    form = agent.page.forms.last
    form.nr = number
    form.submit

    out = {}

    agent.page.search(".veranstaltung").each do |event|
      event.search(".ort a").each do |link|
        url = link.attributes["href"].value
        out[:address] = url.slice(30..url.length)
      end
      @date = event.search(".kategorie").first.text.slice(0..9)

    end
    agent.page.search(".markierung").each do |item|
      out[:kind] = item.search(".turnier").first.text
      @time = item.search(".uhrzeit").first.text
      out[:notes] = item.search(".bemerkung").first.text
    end

    out[:date] = DateTime.parse "#{@time} #{@date}"

    return out
  end

  def setActivePage
    @active_page = 'results'
  end
end
