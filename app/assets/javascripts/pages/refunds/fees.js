var refundFeesPage = (function() {
    var refundFeesPage = {};
    var privateFields = {};
    function updateTotalFees() {
        var values = [];
        values.push(privateFields.etIssueFeeEl().val());
        values.push(privateFields.etHearingFeeEl().val());
        values.push(privateFields.etReconsiderationFeeEl().val());
        values.push(privateFields.eatIssueFeeEl().val());
        values.push(privateFields.eatHearingFeeEl().val());
        var total = values.reduce(function(sum, value) {
            if(value === '') {
                return sum;
            }
            return sum + parseFloat(value);
        }, 0);
        $('.main-content.refunds_fees span[data-behavior=\'total_fees\']').text(total.toFixed(2));
    }
    function enableOtherFieldsWhenAllowed() {
        $('.main-content.refunds_fees form input[data-behavior=\'fee_field\']').on('change keyup keypress', updateOtherFields);
    }
    function updateTotalFeesOnChange() {
        $('.main-content.refunds_fees form input[data-behavior=\'fee_field\']').on('change keyup keypress', updateTotalFees);
    }
    privateFields.etIssueFeeEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_issue_fee]\']');
    };
    privateFields.etIssueFeePaymentDateYearEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_issue_fee_payment_date][year]\']');
    };
    privateFields.etIssueFeePaymentDateMonthEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_issue_fee_payment_date][month]\']');
    };
    privateFields.etIssueFeePaymentDateUnknownEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_issue_fee_payment_date_unknown]\']');
    };
    privateFields.etIssueFeePaymentMethodEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_issue_fee_payment_method]\']');
    };
    privateFields.etHearingFeeEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_hearing_fee]\']');
    };
    privateFields.etHearingFeePaymentDateYearEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_date][year]\']');
    };
    privateFields.etHearingFeePaymentDateMonthEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_date][month]\']');
    };
    privateFields.etHearingFeePaymentDateUnknownEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_date_unknown]\']');
    };
    privateFields.etHearingFeePaymentMethodEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_method]\']');
    };
    privateFields.etReconsiderationFeeEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_reconsideration_fee]\']');
    };
    privateFields.etReconsiderationFeePaymentDateYearEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_date][year]\']');
    };
    privateFields.etReconsiderationFeePaymentDateMonthEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_date][month]\']');
    };
    privateFields.etReconsiderationFeePaymentDateUnknownEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_date_unknown]\']');
    };
    privateFields.etReconsiderationFeePaymentMethodEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_method]\']');
    };

    privateFields.eatIssueFeeEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_issue_fee]\']')
    };
    privateFields.eatIssueFeePaymentDateYearEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_date][year]\']');
    };
    privateFields.eatIssueFeePaymentDateMonthEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_date][month]\']');
    };
    privateFields.eatIssueFeePaymentDateUnknownEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_date_unknown]\']');
    };
    privateFields.eatIssueFeePaymentMethodEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_method]\']');
    };
    privateFields.eatHearingFeeEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_hearing_fee]\']');
    };
    privateFields.eatHearingFeePaymentDateYearEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_date][year]\']');
    };
    privateFields.eatHearingFeePaymentDateMonthEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_date][month]\']');
    };
    privateFields.eatHearingFeePaymentDateUnknownEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_date_unknown]\']');
    };
    privateFields.eatHearingFeePaymentMethodEl = function() {
        return $('.main-content.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_method]\']');
    };
    function updateOtherFields() {
        ['etIssue', 'etHearing', 'etReconsideration', 'eatIssue', 'eatHearing'].forEach(function (f) {
            var val = privateFields[f + 'FeeEl']().val();
            var disabled = (isNaN(val) || val == 0.0);
            setDisabledForFee(f, disabled);
        });
    }
    function setDisabledForFee(fee, value) {
        privateFields[fee + 'FeePaymentDateYearEl']().prop('disabled', value);
        privateFields[fee + 'FeePaymentDateMonthEl']().prop('disabled', value);
        privateFields[fee + 'FeePaymentDateUnknownEl']().prop('disabled', value);
        privateFields[fee + 'FeePaymentMethodEl']().prop('disabled', value);
    }
    refundFeesPage.init = function() {
        updateTotalFees();
        updateOtherFields();
        updateTotalFeesOnChange();
        enableOtherFieldsWhenAllowed();
    };
    return refundFeesPage;
})();
