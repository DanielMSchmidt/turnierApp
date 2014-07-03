require 'spec_helper'
include Devise::TestHelpers

describe Api::V1::SessionsController do
  let!(:user) { FactoryGirl.create(:user) }

  describe 'access' do
    describe '#login' do
      it 'should return the right api token if given right credentials' do
        post :login, {}, {email: 'test@testuser.de', password: 'testtest12345'}

        expect(json).to have_key('token')
        expect(json.token).to equal(user.authentication_token)
        should respond_with 200
      end

      it 'should return an not authorized response if given wrong credentials' do
        pending
      end
    end

    describe '#logout' do
      it 'should return success and logout the user' do
        pending
      end
    end
  end
end