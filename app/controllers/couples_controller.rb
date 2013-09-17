# -*- encoding : utf-8 -*-
class CouplesController < ApplicationController

  before_filter :getRequestData, only: [:create, :update]

  # POST /couples
  # POST /couples.json
  def create
    if @couple.consistsOfCurrentUser(current_user)
      if @couple.save
        @couple.activate
        redirect_to root_path, notice: t('couple.create.success')
      end
    else
      redirect_to root_path, error: t('couple.create.fail')
    end
  end

  # PUT /couples/1
  # PUT /couples/1.json
  def update
    if (@man_id.nil? || @woman_id.nil?)
      redirect_to root_path, error: t('couple.update.fail') and return
    end

    if @couple.consistsOfCurrentUser(current_user)
      if @couple.save
        @couple.activate
        # FIXME: Shouldn't be needed, investigate here!
        @couple.standard.start_class = standard_class
        @couple.standard.save!
        @couple.latin.start_class = latin_class
        @couple.latin.save!
        redirect_to root_path, notice: t('couple.update.success')
      end
    else
      redirect_to root_path, error: t('couple.create.fail')
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

  def createNewCouple(man_id, woman_id)
    couple = Couple.new(man_id: man_id, woman_id: woman_id)

    #Add Progresses
    latin = couple.progresses.new(start_class: params[:couple][:latin_kind], kind: 'latin')
    standard = couple.progresses.new(start_class: params[:couple][:standard_kind], kind: 'standard')

    couple
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

  def getRequestData
    @man_id = User.getIdByName(params[:couple][:man])
    @woman_id = User.getIdByName(params[:couple][:woman])
    latin_class = params[:couple][:latin_kind]
    standard_class = params[:couple][:standard_kind]

     @couple = createNewCouple(@man_id, @woman_id)
  end
end
