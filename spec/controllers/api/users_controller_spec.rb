require 'spec_helper'
include Devise::TestHelpers

describe Api::V1::UsersController, :type => :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:woman) { FactoryGirl.create(:woman) }
  let!(:couple) { FactoryGirl.create(:couple) }

  before(:each) do
    @userHeader = { 'HTTP_X_ACCESS_EMAIL' => user.email, 'HTTP_X_ACCESS_TOKEN' => user.authentication_token }
  end

  it 'should get an unauthorized if approached without token' do
    clearToken
    get :information, {token: 'NoValidToken'}

    should respond_with 403
  end

  describe '#information' do
    render_views

    before(:each) do
      allow(controller).to receive(:sign_in)
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:partner).and_return(woman)

      authWithUser(user)

      get :information, :format => :json

      should respond_with 200
    end

    it 'should get the user information' do
      expect(json['id']).to eq(user.id)
      expect(json['name']).to eq('Test User')
      expect(json['email']).to eq('test@testuser.de')
    end

    it 'should get the start classes' do
      expect(json['startclass']).to eq({'standard' => 'D', 'latin' => 'D'})
    end

    it 'should get the dancing partner' do
      expect(json['partner']).to eq({'email' => woman.email, 'name' => woman.name, 'id' => woman.id})
    end

    it 'should get the clubs of the user' do
      expect(json).to have_key('clubs')
    end

    it 'should get information what a startclass needs in total to be finished' do
      expect(json['startclass_goals']).to eq({'standard' => {'points' => 100, 'placings' => 7}, 'latin' => {'points' => 100, 'placings' => 7}})
    end
  end

  describe '#setPartner' do
    it 'should change the partner' do
      pending
      allow(controller).to receive(:sign_in)
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:partner).and_return(woman)
      expect(user).to receive(:setPartner)
      authWithUser(user)

      post :setPartner, { woman: 42 }, :format => :json

      should respond_with 200
    end
  end

  describe '#setStartClass' do
    it 'should set the right start class'
  end
end