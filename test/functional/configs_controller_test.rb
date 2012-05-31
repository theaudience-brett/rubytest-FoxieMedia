require 'test_helper'

class ConfigsControllerTest < ActionController::TestCase
  setup do
    @global_config = global_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create global_config" do
    assert_difference('AppConfig.count') do
      post :create, global_config: @global_config.attributes
    end

    assert_redirected_to global_config_path(assigns(:global_config))
  end

  test "should show global_config" do
    get :show, id: @global_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @global_config
    assert_response :success
  end

  test "should update global_config" do
    put :update, id: @global_config, global_config: @global_config.attributes
    assert_redirected_to global_config_path(assigns(:global_config))
  end

  test "should destroy global_config" do
    assert_difference('AppConfig.count', -1) do
      delete :destroy, id: @global_config
    end

    assert_redirected_to global_configs_path
  end
end
