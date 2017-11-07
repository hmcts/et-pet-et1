// Focuses on aria alert if it's in the page for screen readers

var dateRangeInput = (function() {

    var dateRangeInput = {};

    function onYearChange(e) {
        var delegate = $(e.delegateTarget);
        filterMonthSelect(delegate);
    }

    function filterMonthSelect(component) {
        filterMonthsSelect(component);
    }

    function filterMonthsSelect(component) {
        var yearPart = component.find('[data-part="year"]');
        var endDate = component.attr('data-date-range-end');
        var startDate = component.attr('data-date-range-start');
        var yearStart = startDate.split('-')[0];
        var yearEnd = endDate.split('-')[0];
        var monthEnd = parseInt(endDate.split('-')[1]);
        var monthStart = parseInt(startDate.split('-')[1]);
        if(yearPart.val() == yearStart) {
            enableMonths(component, monthStart, 12);
        } else if(yearPart.val() == yearEnd) {
            enableMonths(component, 1, monthEnd);
        } else {
            enableMonths(component, 1,12);
        }
    }

    function enableMonths(component, startMonth, endMonth) {
        var monthPart = component.find('[data-part="month"]');
        monthPart.find('option').each(function(_idx, option) {
            if(option.value === '') {
                return;
            }
            if(parseInt(option.value) < startMonth || parseInt(option.value) > endMonth) {
                $(option).prop('disabled', true);
            } else {
                $(option).prop('disabled', false);
            }
        });

    }

    dateRangeInput.init = function() {
        $('[data-date-range-input]').on('change', '[data-part="year"]', onYearChange);
    };
    $(document).ready(dateRangeInput.init);
    return dateRangeInput;
})();
