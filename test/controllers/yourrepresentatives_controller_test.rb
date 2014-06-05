require 'test_helper'

class YourrepresentativesControllerTest < ActionController::TestCase
  setup do
    @yourrepresentative = yourrepresentatives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yourrepresentatives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yourrepresentative" do
    assert_difference('Yourrepresentative.count') do
      post :create, yourrepresentative: { building_number_name: @yourrepresentative.building_number_name, county: @yourrepresentative.county, dx_number: @yourrepresentative.dx_number, email: @yourrepresentative.email, mobile: @yourrepresentative.mobile, postcode: @yourrepresentative.postcode, representative_name: @yourrepresentative.representative_name, representative_organisation: @yourrepresentative.representative_organisation, street: @yourrepresentative.street, telephone: @yourrepresentative.telephone, town_city: @yourrepresentative.town_city, type_of_representative: @yourrepresentative.type_of_representative }
    end

    assert_redirected_to yourrepresentative_path(assigns(:yourrepresentative))
  end

  test "should show yourrepresentative" do
    get :show, id: @yourrepresentative
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yourrepresentative
    assert_response :success
  end

  test "should update yourrepresentative" do
    patch :update, id: @yourrepresentative, yourrepresentative: { building_number_name: @yourrepresentative.building_number_name, county: @yourrepresentative.county, dx_number: @yourrepresentative.dx_number, email: @yourrepresentative.email, mobile: @yourrepresentative.mobile, postcode: @yourrepresentative.postcode, representative_name: @yourrepresentative.representative_name, representative_organisation: @yourrepresentative.representative_organisation, street: @yourrepresentative.street, telephone: @yourrepresentative.telephone, town_city: @yourrepresentative.town_city, type_of_representative: @yourrepresentative.type_of_representative }
    assert_redirected_to yourrepresentative_path(assigns(:yourrepresentative))
  end

  test "should destroy yourrepresentative" do
    assert_difference('Yourrepresentative.count', -1) do
      delete :destroy, id: @yourrepresentative
    end

    assert_redirected_to yourrepresentatives_path
  end
end
