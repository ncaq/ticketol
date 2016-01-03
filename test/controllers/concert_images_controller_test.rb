require 'test_helper'

class ConcertImagesControllerTest < ActionController::TestCase
  setup do
    @concert_image = concert_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:concert_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create concert_image" do
    assert_difference('ConcertImage.count') do
      post :create, concert_image: { concert_id: @concert_image.concert_id, data: @concert_image.data }
    end

    assert_redirected_to concert_image_path(assigns(:concert_image))
  end

  test "should show concert_image" do
    get :show, id: @concert_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @concert_image
    assert_response :success
  end

  test "should update concert_image" do
    patch :update, id: @concert_image, concert_image: { concert_id: @concert_image.concert_id, data: @concert_image.data }
    assert_redirected_to concert_image_path(assigns(:concert_image))
  end

  test "should destroy concert_image" do
    assert_difference('ConcertImage.count', -1) do
      delete :destroy, id: @concert_image
    end

    assert_redirected_to concert_images_path
  end
end
