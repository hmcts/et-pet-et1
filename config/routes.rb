require 'sidekiq/web'

Rails.application.routes.draw do
  scope :apply do
    resource :guide,              only: :show
    resource :terms,              only: :show
    resource :cookies,            only: :show
    resource :claim_review,       only: %i<show update>, path: :review
    resource :pdf,                only: :show
    resource :claim_confirmation, only: :show, path: :confirmation

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

    resource :refund, only: [:create, :new], path: "/refund" do
      RefundPagesManager.page_names.each do |page|
        resource page.underscore, only: %i<show update>, controller: :refunds,
          page: page, path: page
      end
    end

    get 'ping' => 'ping#index'

    get 'healthcheck' => 'healthcheck#index'

    resource :user_session, only: %i<create destroy new>, path: :session do
      member do
        get :touch
        get :expired
      end
    end

    get  '/feedback' => 'feedback#new'
    post '/feedback' => 'feedback#create'

    get '/barclaycard-payment-template' => 'barclaycard_payment_template#show'

    get '/stats' => 'stats#index'

    resources :diversities do
      get 'submit'
    end

    constraints(ip: /81\.134\.202\.29|127\.0\.0\.1|172\.\d+\.\d+\.\d+/) do
      ActiveAdmin.routes(self)
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  get '/apply' => 'claims#new'
  get '/apply/refund' => 'refunds#new'
  root to: redirect('/apply')
end
