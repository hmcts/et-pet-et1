require 'test_helper'

class ClaimDetailsControllerTest < ActionController::TestCase
  setup do
    @claim_detail = claim_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:claim_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create claim_detail" do
    assert_difference('ClaimDetail.count') do
      post :create, claim_detail: { additional_information: @claim_detail.additional_information, compensation_other_outcome: @claim_detail.compensation_other_outcome, discrimination: @claim_detail.discrimination, other_complaints: @claim_detail.other_complaints, pay: @claim_detail.pay, rtf_file: @claim_detail.rtf_file, similar_claims: @claim_detail.similar_claims, similar_claims_names: @claim_detail.similar_claims_names, type_of_claims: @claim_detail.type_of_claims, unfairly_dismissed: @claim_detail.unfairly_dismissed, want_if_claim_successful: @claim_detail.want_if_claim_successful, whistleblowing_claim: @claim_detail.whistleblowing_claim }
    end

    assert_redirected_to claim_detail_path(assigns(:claim_detail))
  end

  test "should show claim_detail" do
    get :show, id: @claim_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @claim_detail
    assert_response :success
  end

  test "should update claim_detail" do
    patch :update, id: @claim_detail, claim_detail: { additional_information: @claim_detail.additional_information, compensation_other_outcome: @claim_detail.compensation_other_outcome, discrimination: @claim_detail.discrimination, other_complaints: @claim_detail.other_complaints, pay: @claim_detail.pay, rtf_file: @claim_detail.rtf_file, similar_claims: @claim_detail.similar_claims, similar_claims_names: @claim_detail.similar_claims_names, type_of_claims: @claim_detail.type_of_claims, unfairly_dismissed: @claim_detail.unfairly_dismissed, want_if_claim_successful: @claim_detail.want_if_claim_successful, whistleblowing_claim: @claim_detail.whistleblowing_claim }
    assert_redirected_to claim_detail_path(assigns(:claim_detail))
  end

  test "should destroy claim_detail" do
    assert_difference('ClaimDetail.count', -1) do
      delete :destroy, id: @claim_detail
    end

    assert_redirected_to claim_details_path
  end
end
