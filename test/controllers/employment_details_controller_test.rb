require 'test_helper'

class EmploymentDetailsControllerTest < ActionController::TestCase
  setup do
    @employment_detail = employment_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employment_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employment_detail" do
    assert_difference('EmploymentDetail.count') do
      post :create, employment_detail: { current_situation: @employment_detail.current_situation, details_of_benefit: @employment_detail.details_of_benefit, hours_worked: @employment_detail.hours_worked, job_title: @employment_detail.job_title, pay_before_tax: @employment_detail.pay_before_tax, pay_before_tax_frequency: @employment_detail.pay_before_tax_frequency, pension_scheme: @employment_detail.pension_scheme, start_date: @employment_detail.start_date, take_home_pay: @employment_detail.take_home_pay, take_home_pay_frequency: @employment_detail.take_home_pay_frequency }
    end

    assert_redirected_to employment_detail_path(assigns(:employment_detail))
  end

  test "should show employment_detail" do
    get :show, id: @employment_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employment_detail
    assert_response :success
  end

  test "should update employment_detail" do
    patch :update, id: @employment_detail, employment_detail: { current_situation: @employment_detail.current_situation, details_of_benefit: @employment_detail.details_of_benefit, hours_worked: @employment_detail.hours_worked, job_title: @employment_detail.job_title, pay_before_tax: @employment_detail.pay_before_tax, pay_before_tax_frequency: @employment_detail.pay_before_tax_frequency, pension_scheme: @employment_detail.pension_scheme, start_date: @employment_detail.start_date, take_home_pay: @employment_detail.take_home_pay, take_home_pay_frequency: @employment_detail.take_home_pay_frequency }
    assert_redirected_to employment_detail_path(assigns(:employment_detail))
  end

  test "should destroy employment_detail" do
    assert_difference('EmploymentDetail.count', -1) do
      delete :destroy, id: @employment_detail
    end

    assert_redirected_to employment_details_path
  end
end
