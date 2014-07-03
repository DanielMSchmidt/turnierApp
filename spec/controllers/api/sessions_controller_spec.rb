require 'spec_helper'
include Devise::TestHelpers

describe Api::V1::SessionsController do
  let!(:user) { FactoryGirl.create(:user) }

  describe 'access' do
    describe '#login' do
      it 'should return the right api token if given right credentials' do
        post :login, {email: 'test@testuser.de', password: 'testtest12345'}

        should respond_with 200
        expect(json).to have_key('token')
        expect(json['token']).to eq(user.authentication_token)
      end

      it 'should return an not authorized response if given wrong credentials' do
        post :login, {email: 'test@testuser.de', password: 'wrong password'}

        should respond_with 403
        expect(json).not_to have_key('token')
      end
    end
  end
end