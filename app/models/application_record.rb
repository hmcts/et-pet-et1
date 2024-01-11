class ApplicationRecord < ::ActiveRecord::Base
  self.abstract_class = true

  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransack(*args, **kw_args)
    if args.first.is_a?(Hash) || args.first.is_a?(ActionController::Parameters)
      my_params = enhance_date_range_search(args.first)
      super my_params, **kw_args
    else
      super *args, **kw_args
    end
  end

  private

  def self.enhance_date_range_search(params)
    my_params = params.dup

    my_params.keys.select do |key|
      next unless key.ends_with?('_lteq') && my_params.key?(key.sub('_lteq', '_gteq')) && is_date_time_type?(key.sub('_lteq', ''))

      my_params[key] = my_params[key] + ' 23:59:59'
    end
    my_params
  end

  def self.is_date_time_type?(key)
    columns_hash[key].type == :datetime
  end
end
