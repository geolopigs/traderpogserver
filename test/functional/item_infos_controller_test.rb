require 'test_helper'

class ItemInfosControllerTest < ActionController::TestCase
  setup do
    @item_info = item_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_info" do
    assert_difference('ItemInfo.count') do
      post :create, item_info: @item_info.attributes
    end

    assert_redirected_to item_info_path(assigns(:item_info))
  end

  test "should show item_info" do
    get :show, id: @item_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_info
    assert_response :success
  end

  test "should update item_info" do
    put :update, id: @item_info, item_info: @item_info.attributes
    assert_redirected_to item_info_path(assigns(:item_info))
  end

  test "should destroy item_info" do
    assert_difference('ItemInfo.count', -1) do
      delete :destroy, id: @item_info
    end

    assert_redirected_to item_infos_path
  end
end
