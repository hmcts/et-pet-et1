// Focuses on aria alert if it's in the page for screen readers

var dateRangeInput = (function() {

    var dateRangeInput = {};

    function onYearChange(e) {
        var delegate = $(e.delegateTarget);
        filterMonthSelect(delegate);
    }

    function filterMonthSelect(component) {
        filterMonthsSelectOnStartDate(component);
        filterMonthsSelectOnEndDate(component);
    }

    function filterMonthsSelectOnStartDate(component) {
        var monthPart = component.find('[data-part="month"]');
        var yearPart = component.find('[data-part="year"]');
        var startDate = component.attr('data-date-range-start');
        var yearStart = startDate.split('-')[0];
        if(yearPart.val() === yearStart) {
            var startMonth = parseInt(startDate.split('-')[1]);
            monthPart.find('option').each(function(_idx, option) {
                if(option.value === '') {
                    return;
                }
                if(parseInt(option.value) < startMonth) {
                    $(option).prop('disabled', true);
                } else {
                    $(option).prop('disabled', false);
                }
            });
        }
    }

    function filterMonthsSelectOnEndDate(component) {
        var monthPart = component.find('[data-part="month"]');
        var yearPart = component.find('[data-part="year"]');
        var endDate = component.attr('data-date-range-end');
        var yearEnd = endDate.split('-')[0];
        if(yearPart.val() === yearEnd) {
            var endMonth = parseInt(endDate.split('-')[1]);
            monthPart.find('option').each(function(_idx, option) {
                if(option.value === '') {
                    return;
                }
                if(parseInt(option.value) > endMonth) {
                    $(option).prop('disabled', true);
                } else {
                    $(option).prop('disabled', false);
                }
            });
        }
    }

    dateRangeInput.init = function() {
        $('[data-date-range-input]').on('change', '[data-part="year"]', onYearChange);
    };
    $(document).ready(dateRangeInput.init);
    return dateRangeInput;
})();
