#encoding: utf-8
class MembershipController < ApplicationController
  def create
    Membership.create!(user_id: params[:user_id], club_id: params[:club_id], verified: false)
    redirect_to clubs_path, notice: 'Der Verein wurde erfolgreich zu deinen Vereinen hinzugefügt. Sie müssen jetzt lediglich noch bestätigt werden.'
  end

  def verify
    membership = Membership.where(user_id: params[:user_id], club_id: params[:club_id]).first
    if membership
      membership.verified = true
      membership.save!
      redirect_to  club_path(params[:club_id]), notice: 'Der Nuter wurde bestätigt.'
    else
      redirect_to  club_path(params[:club_id]), notice: 'Der Nuter konnte nicht bestätigt werden.'
    end
  end

  def destroy
    @membership = Membership.destroy_all(club_id: params[:club_id], user_id: params[:user_id])
    redirect_to edit_user_registration_path(current_user), notice: 'Der Verein wurde erfolgreich aus deinen Vereinen gelöscht.'
  end

end
