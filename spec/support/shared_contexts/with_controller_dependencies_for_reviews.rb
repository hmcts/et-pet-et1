shared_context 'with controller dependencies for reviews' do
  before do
    controller.singleton_class.class_eval %Q{
        include Rails.application.routes.url_helpers
        protected
        def claim_path_for(page, options = {})
          send "claim_\#{page}_path".underscore, options
        end

        helper_method :claim, :claim_path_for
      }
  end
end
