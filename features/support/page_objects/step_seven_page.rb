class StepSevenPage < BasePage

  section :your_employment_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Your employment details")]] }) do
    def set(value)
      choose value, name: "employment[was_employed]"
    end

    section :current_work_situation, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.starts_with("What is your current work situation in relation to the employer")]] }) do
      def set(value)
        choose value, name: "employment[current_situation]"
      end
    end

    section :employment_details, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Employment details")]] }) do
      element :job_title, 'input[name="employment[job_title]"]'
      section :start_date, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Employment start date")]] }) do
        element :day, 'input[name="employment[start_date][day]"]'
        element :month, 'input[name="employment[start_date][month]"]'
        element :year, 'input[name="employment[start_date][year]"]'
        def set(value)
          (day_value, month_value, year_value) = value.split("/")
          day.set(day_value)
          month.set(month_value)
          year.set(year_value)
        end
      end
      section :notice_period, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Did you work (or get paid for) a period of notice?")]] }) do
        def set(value)
          choose value, name: "employment[worked_notice_period_or_paid_in_lieu]"
        end
      end
      section :notice_period_value, '.employment_notice_pay_period_count' do
        element :count, 'input[name="employment[notice_pay_period_count]"]'
        def set(value)
          (count_value, unit) = value.split(" ")
          count.set(count_value)
          choose unit, name: "employment[notice_pay_period_type]"
        end
      end
      element :average_weekly_hours, 'input[name="employment[average_hours_worked_per_week]"]'
    end
    section :pay_pension_benefits, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Pay, pension and benefits")]] }) do
      section :pay_before_tax, '.employment_gross_pay' do
        element :gross_pay, 'input[name="employment[gross_pay]"]'
        def set(value)
          (gross_pay_value, unit) = value.split(" ")
          gross_pay.set(gross_pay_value)
          choose unit, name: "employment[gross_pay_period_type]"
        end
      end
      section :pay_after_tax, '.employment_net_pay' do
        element :net_pay, 'input[name="employment[net_pay]"]'
        def set(value)
          (net_pay_value, unit) = value.split(" ")
          net_pay.set(net_pay_value)
          choose unit, name: "employment[net_pay_period_type]"
        end
      end
      section :employers_pension_scheme, '.employment_enrolled_in_pension_scheme' do
        def set(value)
          choose value, name: 'employment[enrolled_in_pension_scheme]'
        end
      end
      element :benefits, 'textarea[name="employment[benefit_details]"]'
    end
  end
  element :save_and_continue, 'form.edit_employment input[value="Save and continue"]'
end
