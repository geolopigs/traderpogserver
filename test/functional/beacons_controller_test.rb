require 'test_helper'

class BeaconsControllerTest < ActionController::TestCase
  setup do
    @beacon = beacons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beacons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beacon" do
    assert_difference('Beacon.count') do
      post :create, beacon: @beacon.attributes
    end

    assert_redirected_to beacon_path(assigns(:beacon))
  end

  test "should show beacon" do
    get :show, id: @beacon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beacon
    assert_response :success
  end

  test "should update beacon" do
    put :update, id: @beacon, beacon: @beacon.attributes
    assert_redirected_to beacon_path(assigns(:beacon))
  end

  test "should destroy beacon" do
    assert_difference('Beacon.count', -1) do
      delete :destroy, id: @beacon
    end

    assert_redirected_to beacons_path
  end
end
