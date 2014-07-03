require 'spec_helper'
include Devise::TestHelpers

describe Api::V1::UsersController do
  let!(:user) { FactoryGirl.create(:user) }

  it 'should get an unauthorized if approached without token' do
    get :information, {token: 'NoValidToken'}

    should respond_with 403
  end

  describe '#information' do
    it 'should get the user information'
    it 'should get the start classes'
    it 'should get the dancing partner'
    it 'should get information if the startclass is finished'
  end

  describe '#setPassword' do
    it 'should set the password accordingly'
  end

  describe '#setPartner' do
    it 'should check if the partner can be changed'
    it 'should change the partner'
  end

  describe '#setStartClass' do
    it 'should set the start class'
  end
end