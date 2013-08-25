# -*- encoding : utf-8 -*-
class ProgressesController < ApplicationController

  # POST /progresses
  # POST /progresses.json
  def create
    @progress = Progress.new(params[:progress])

    respond_to do |format|
      if @progress.save
        format.html { redirect_to @progress, notice: 'Progress was successfully created.' }
        format.json { render json: @progress, status: :created, location: @progress }
      else
        format.html { render action: "new" }
        format.json { render json: @progress.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /progresses/1
  # PUT /progresses/1.json
  def update
    @progress = Progress.find(params[:id])

    respond_to do |format|
      if @progress.update_attributes(params[:progress])
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @progress.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /progresses/1
  # DELETE /progresses/1.json
  def destroy
    @progress = Progress.find(params[:id])
    @progress.destroy

    respond_to do |format|
      format.html { redirect_to progresses_url }
      format.json { head :no_content }
    end
  end
end
