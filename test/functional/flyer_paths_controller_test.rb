require 'test_helper'

class FlyerPathsControllerTest < ActionController::TestCase
  setup do
    @flyer_path = flyer_paths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flyer_paths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flyer_path" do
    assert_difference('FlyerPath.count') do
      post :create, flyer_path: @flyer_path.attributes
    end

    assert_redirected_to flyer_path_path(assigns(:flyer_path))
  end

  test "should show flyer_path" do
    get :show, id: @flyer_path
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @flyer_path
    assert_response :success
  end

  test "should update flyer_path" do
    put :update, id: @flyer_path, flyer_path: @flyer_path.attributes
    assert_redirected_to flyer_path_path(assigns(:flyer_path))
  end

  test "should destroy flyer_path" do
    assert_difference('FlyerPath.count', -1) do
      delete :destroy, id: @flyer_path
    end

    assert_redirected_to flyer_paths_path
  end
end
