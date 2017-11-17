And(/^I answer Yes to the have you ever been employed by the person you are making the claim against question$/) do
  step_seven_page.your_employment_details.set("Yes")
end

And(/^I answer "([^"]*)" to the current work situation question$/) do |answer|
  step_seven_page.your_employment_details.current_work_situation.set(answer)
end

And(/^I fill in the employment details with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_seven_page.your_employment_details.employment_details do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I fill in my employment details for an employee tribunal$/) do
  employment = test_user.et_case.employment
  step_seven_page.your_employment_details.current_work_situation.set(employment.current_situation)
  step_seven_page.your_employment_details.employment_details do |section|
    section.job_title.set employment.job_title
    section.start_date.set employment.start_date
    section.notice_period.set employment.notice_period
    section.notice_period_value.set employment.notice_period_value
    section.average_weekly_hours.set employment.average_weekly_hours
  end
  step_seven_page.your_employment_details.pay_pension_benefits do |section|
    section.pay_before_tax.set employment.pay_before_tax
    section.pay_after_tax.set employment.pay_after_tax
    section.employers_pension_scheme.set employment.employers_pension_scheme
    section.benefits.set employment.benefits
  end
end

And(/^I fill in the pay, pension and benefits with:$/) do |table|
  # table is a table.hashes.keys # => [:field, :value]
  table.hashes.each do |hash|
    step_seven_page.your_employment_details.pay_pension_benefits do |section|
      node = section.send((hash['field']).to_s.to_sym)
      case node.try(:tag_name)
      when "select" then node.select(hash['value'])
      else node.set(hash['value'])
      end
    end
  end
end

And(/^I save the employment details$/) do
  step_seven_page.save_and_continue.click
end
