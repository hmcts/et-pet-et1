require 'test_helper'

class EmployersDetailsControllerTest < ActionController::TestCase
  setup do
    @employers_detail = employers_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employers_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employers_detail" do
    assert_difference('EmployersDetail.count') do
      post :create, employers_detail: { acas_certificate_number: @employers_detail.acas_certificate_number, acas_number: @employers_detail.acas_number, another_employer_same_case: @employers_detail.another_employer_same_case, building_name_number: @employers_detail.building_name_number, county: @employers_detail.county, employed_by_organisation: @employers_detail.employed_by_organisation, name: @employers_detail.name, postcode: @employers_detail.postcode, street: @employers_detail.street, telephone: @employers_detail.telephone, town_city: @employers_detail.town_city, work_address_different: @employers_detail.work_address_different }
    end

    assert_redirected_to employers_detail_path(assigns(:employers_detail))
  end

  test "should show employers_detail" do
    get :show, id: @employers_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employers_detail
    assert_response :success
  end

  test "should update employers_detail" do
    patch :update, id: @employers_detail, employers_detail: { acas_certificate_number: @employers_detail.acas_certificate_number, acas_number: @employers_detail.acas_number, another_employer_same_case: @employers_detail.another_employer_same_case, building_name_number: @employers_detail.building_name_number, county: @employers_detail.county, employed_by_organisation: @employers_detail.employed_by_organisation, name: @employers_detail.name, postcode: @employers_detail.postcode, street: @employers_detail.street, telephone: @employers_detail.telephone, town_city: @employers_detail.town_city, work_address_different: @employers_detail.work_address_different }
    assert_redirected_to employers_detail_path(assigns(:employers_detail))
  end

  test "should destroy employers_detail" do
    assert_difference('EmployersDetail.count', -1) do
      delete :destroy, id: @employers_detail
    end

    assert_redirected_to employers_details_path
  end
end
