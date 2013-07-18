# -*- encoding : utf-8 -*-
class MembershipController < ApplicationController

  def create
    Membership.create!(couple_id: getCoupleFromUser, club_id: params[:club_id], verified: false)
    redirect_to clubs_path, notice: t('membership create')
  end

  def verify
    membership = Membership.where(couple_id: params[:couple_id], club_id: params[:club_id]).first
    if membership
      membership.verified = true
      membership.save!
      redirect_to  club_path(params[:club_id]), notice: t('membership verfify success')
    else
      redirect_to  club_path(params[:club_id]), notice: t('membership verfify fail')
    end
  end

  def destroy
    @membership = Membership.destroy_all(couple_id: params[:couple_id], club_id: params[:club_id])
    redirect_to root_path, notice: t('membership destroy')
  end

  def getCoupleFromUser
    couple_id = User.find(params[:user_id]).activeCouple.id
  end
end
