require 'test_helper'

class UserFlyersControllerTest < ActionController::TestCase
  setup do
    @user_flyer = user_flyers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_flyers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_flyer" do
    assert_difference('UserFlyer.count') do
      post :create, user_flyer: @user_flyer.attributes
    end

    assert_redirected_to user_flyer_path(assigns(:user_flyer))
  end

  test "should show user_flyer" do
    get :show, id: @user_flyer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_flyer
    assert_response :success
  end

  test "should update user_flyer" do
    put :update, id: @user_flyer, user_flyer: @user_flyer.attributes
    assert_redirected_to user_flyer_path(assigns(:user_flyer))
  end

  test "should destroy user_flyer" do
    assert_difference('UserFlyer.count', -1) do
      delete :destroy, id: @user_flyer
    end

    assert_redirected_to user_flyers_path
  end
end
