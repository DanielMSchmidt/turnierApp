# -*- encoding : utf-8 -*-
class CouplesController < ApplicationController

  #FIXME: Dry Post and Put up

  # POST /couples
  # POST /couples.json
  def create
    man_id = User.get_id_by_name(params[:couple][:man])
    woman_id = User.get_id_by_name(params[:couple][:woman])

    @couple = createNewCouple(man_id, woman_id)
    if @couple.consistsOfCurrentUser(current_user)
      if @couple.save
        @couple.activate
        redirect_to root_path, notice: t('couple create success')
      end
    else
      redirect_to root_path, error: t('couple create fail')
    end
  end

  # PUT /couples/1
  # PUT /couples/1.json
  def update
    man_id = User.get_id_by_name(params[:couple][:man])
    woman_id = User.get_id_by_name(params[:couple][:woman])

    @couple = createNewCouple(man_id, woman_id)
    if @couple.consistsOfCurrentUser(current_user)
      if @couple.save
        @couple.activate
        redirect_to root_path, notice: t('couple update success')
      end
    else
      redirect_to root_path, error: t('couple create fail')
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
end
