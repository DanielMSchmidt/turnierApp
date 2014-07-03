require 'spec_helper'
include Devise::TestHelpers

describe Api::V1::SessionsController do
  describe 'access' do
    describe '#login' do
      it('should return the right api token if given right credentials')
      it('should return an not authorized response if given wrong credentials')
    end

    describe '#logout' do
      it('should return success and logout the user')
    end
  end
end