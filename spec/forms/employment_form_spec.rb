require 'rails_helper'

RSpec.describe EmploymentForm, :type => :form do
  it_behaves_like 'it parses and validates multiparameter dates',
    :start_date, :end_date, :notice_period_end_date, :new_job_start_date
end
