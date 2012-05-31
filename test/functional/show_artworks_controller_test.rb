require 'test_helper'

class ShowArtworksControllerTest < ActionController::TestCase
  setup do
    @show_artwork = show_artworks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:show_artworks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create show_artwork" do
    assert_difference('ShowArtwork.count') do
      post :create, show_artwork: @show_artwork.attributes
    end

    assert_redirected_to show_artwork_path(assigns(:show_artwork))
  end

  test "should show show_artwork" do
    get :show, id: @show_artwork
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @show_artwork
    assert_response :success
  end

  test "should update show_artwork" do
    put :update, id: @show_artwork, show_artwork: @show_artwork.attributes
    assert_redirected_to show_artwork_path(assigns(:show_artwork))
  end

  test "should destroy show_artwork" do
    assert_difference('ShowArtwork.count', -1) do
      delete :destroy, id: @show_artwork
    end

    assert_redirected_to show_artworks_path
  end
end
