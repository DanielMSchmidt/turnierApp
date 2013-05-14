# -*- encoding : utf-8 -*-
class CouplesController < ApplicationController
  # GET /couples
  # GET /couples.json
  def index
    @couples = Couple.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @couples }
    end
  end

  # GET /couples/1
  # GET /couples/1.json
  def show
    @couple = Couple.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @couple }
    end
  end

  # GET /couples/new
  # GET /couples/new.json
  def new
    @couple = Couple.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @couple }
    end
  end

  # GET /couples/1/edit
  def edit
    @couple = Couple.find(params[:id])
  end

  # POST /couples
  # POST /couples.json
  def create
    man_id = User.get_id_by_name(params[:couple][:man])
    woman_id = User.get_id_by_name(params[:couple][:woman])

    @couple = Couple.new(man_id: man_id, woman_id: woman_id, active: true)

    #Add Progresses
    latin = @couple.progresses.new(start_class: params[:couple][:latin_kind], kind: 'latin')
    standard = @couple.progresses.new(start_class: params[:couple][:standard_kind], kind: 'standard')

    respond_to do |format|
      if @couple.save
        redirect_to root_path
      else
        format.html { render action: "new" }
        format.json { render json: @couple.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /couples/1
  # PUT /couples/1.json
  def update
    @couple = Couple.find(params[:id])

    #FIXME: See at create and change update like it

    respond_to do |format|
      format.html { redirect_to @couple, notice: 'Couple was successfully updated.' }
      format.json { head :no_content }
    end
  end

  # DELETE /couples/1
  # DELETE /couples/1.json
  def destroy
    @couple = Couple.find(params[:id])
    @couple.destroy

    respond_to do |format|
      format.html { redirect_to couples_url }
      format.json { head :no_content }
    end
  end

  # TODO: Dry up
  def levelup
    couple = current_user.activeCouple
    if params[:kind] == 'latin'
      couple.latin.levelUp
    else
      couple.standard.levelUp
    end
    respond_to :js
  end

  def reset
    couple = current_user.activeCouple
    if params[:kind] == 'latin'
      couple.latin.reset
    else
      couple.standard.reset
    end
    respond_to :js
  end
end
