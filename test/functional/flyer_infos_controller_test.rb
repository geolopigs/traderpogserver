require 'test_helper'

class FlyerInfosControllerTest < ActionController::TestCase
  setup do
    @flyer_info = flyer_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flyer_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flyer_info" do
    assert_difference('FlyerInfo.count') do
      post :create, flyer_info: @flyer_info.attributes
    end

    assert_redirected_to flyer_info_path(assigns(:flyer_info))
  end

  test "should show flyer_info" do
    get :show, id: @flyer_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @flyer_info
    assert_response :success
  end

  test "should update flyer_info" do
    put :update, id: @flyer_info, flyer_info: @flyer_info.attributes
    assert_redirected_to flyer_info_path(assigns(:flyer_info))
  end

  test "should destroy flyer_info" do
    assert_difference('FlyerInfo.count', -1) do
      delete :destroy, id: @flyer_info
    end

    assert_redirected_to flyer_infos_path
  end
end
