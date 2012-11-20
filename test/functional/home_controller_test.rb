require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get impressum" do
    get :impressum
    assert_response :success
  end

end
