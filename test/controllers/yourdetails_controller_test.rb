require 'test_helper'

class YourdetailsControllerTest < ActionController::TestCase
  setup do
    @yourdetail = yourdetails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yourdetails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yourdetail" do
    assert_difference('Yourdetail.count') do
      post :create, yourdetail: { building_number_name: @yourdetail.building_number_name, contact_method: @yourdetail.contact_method, county: @yourdetail.county, date_of_birth: @yourdetail.date_of_birth, disability: @yourdetail.disability, first_name: @yourdetail.first_name, gender: @yourdetail.gender, help_with_fees: @yourdetail.help_with_fees, last_name: @yourdetail.last_name, mobile: @yourdetail.mobile, postcode: @yourdetail.postcode, reprasentative: @yourdetail.reprasentative, street: @yourdetail.street, telephone: @yourdetail.telephone, title: @yourdetail.title, town_city: @yourdetail.town_city }
    end

    assert_redirected_to yourdetail_path(assigns(:yourdetail))
  end

  test "should show yourdetail" do
    get :show, id: @yourdetail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yourdetail
    assert_response :success
  end

  test "should update yourdetail" do
    patch :update, id: @yourdetail, yourdetail: { building_number_name: @yourdetail.building_number_name, contact_method: @yourdetail.contact_method, county: @yourdetail.county, date_of_birth: @yourdetail.date_of_birth, disability: @yourdetail.disability, first_name: @yourdetail.first_name, gender: @yourdetail.gender, help_with_fees: @yourdetail.help_with_fees, last_name: @yourdetail.last_name, mobile: @yourdetail.mobile, postcode: @yourdetail.postcode, reprasentative: @yourdetail.reprasentative, street: @yourdetail.street, telephone: @yourdetail.telephone, title: @yourdetail.title, town_city: @yourdetail.town_city }
    assert_redirected_to yourdetail_path(assigns(:yourdetail))
  end

  test "should destroy yourdetail" do
    assert_difference('Yourdetail.count', -1) do
      delete :destroy, id: @yourdetail
    end

    assert_redirected_to yourdetails_path
  end
end
