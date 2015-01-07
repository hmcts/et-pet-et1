Rails.application.routes.draw do

  resource :guide, only: :show

  resource :terms, only: :show

  resource :cookies, only: :show

  resource :maintenance, only: :show

  resource :user_session, only: %i<create update>, path: :application do
    member do
      %w<reminder returning refresh-session session-expired>.each do |page|
        get page
      end
    end
  end

  scope :apply do
    resource :claim_review, only: %i<show update>, path: :review

    resource :claim_confirmation, only: :show, path: :confirmation

    resource :pdf, only: :show

    resource :claim, only: :create, path: "/" do
      resource :payment, only: %i<show update>, path: :pay do
        member do
          %i<success decline>.each do |result|
            get result, to: "payments##{result}", as: result
          end
        end
      end

      %w<claimants respondents>.each do |page|
        resource :"additional_#{page}", only: %i<show update>,
          controller: :multiples, page: "additional-#{page}",
          path: "additional-#{page}"
      end

      ClaimPagesManager.page_names.each do |page|
        resource page.underscore, only: %i<show update>, controller: :claims,
          page: page, path: page
      end
    end
  end

  root to: 'claims#new'

  get 'ping' => 'ping#index'
end
