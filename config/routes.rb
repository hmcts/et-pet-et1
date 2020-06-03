require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  match "/404", :to => "errors#not_found", :via => :all
  match "/422", :to => "errors#unprocessable", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match "/503", :to => "errors#service_unavailable", :via => :all
  scope "(:locale)", locale: /en|cy/ do
    scope :apply do
      resource :guide,              only: :show
      resource :terms,              only: :show
      resource :cookies,            only: :show
      resource :claim_review,       only: %i<show update>, path: :review
      resource :claim_confirmation, only: :show, path: :confirmation

      resource :claim, only: :create, path: "/" do

        %w<claimants respondents>.each do |page|
          resource :"additional_#{page}", only: %i<show update>,
            controller: :multiples, page: "additional-#{page}",
            path: "additional-#{page}"
        end

        devise_scope :user do
          resource :application_number, only: [:new, :create], path_names: {new: ''}, controller: "save_and_return/registrations", page: 'application-number', path: "application-number"
          resource :session, only: [:new, :create, :destroy], controller: "save_and_return/sessions"
        end
        resource :claimant, only: [:show, :update], controller: :claims, page: 'claimant', path: "claimant"
        resource :additional_claimants, only: [:show, :update], controller: :claims, page: 'additional-claimants', path: "additional-claimants"
        resource :additional_claimants_upload, only: [:show, :update], controller: :claims, page: 'additional-claimants-upload', path: "additional-claimants-upload"
        resource :representative, only: [:show, :update], controller: :claims, page: 'representative', path: "representative"
        resource :respondent, only: [:show, :update], controller: :claims, page: 'respondent', path: "respondent"
        resource :additional_respondents, only: [:show, :update], controller: :claims, page: 'additional-respondents', path: "additional-respondents"
        resource :employment, only: [:show, :update], controller: :claims, page: 'employment', path: "employment"
        resource :claim_type, only: [:show, :update], controller: :claims, page: 'claim-type', path: "claim-type"
        resource :claim_details, only: [:show, :update], controller: :claims, page: 'claim-details', path: "claim-details"
        resource :claim_outcome, only: [:show, :update], controller: :claims, page: 'claim-outcome', path: "claim-outcome"
        resource :additional_information, only: [:show, :update], controller: :claims, page: 'additional-information', path: "additional-information"
        resource :review, only: [:show, :update], controller: :claims, page: 'review', path: "review"
      end

      resource :refund, only: [:create, :new], path: "/refund" do
        RefundPagesManager.page_names.each do |page|
          resource page.underscore, only: %i<show update>, controller: :refunds,
            page: page, path: page
        end
      end

      resource :diversity, only: [:create, :new], path: "/diversity" do
        DiversityPagesManager.page_names.each do |page|
          resource page.underscore, only: %i<show update>, controller: :diversities,
            page: page, path: page
        end
      end
      get 'diversity' => 'diversities#index', as: 'diversity_landing'

      get 'ping' => 'ping#index'

      resource :user_session, only: %i<create destroy new>, path: :session do
        member do
          get :touch
          get :expired
        end
      end

      get  '/feedback' => 'feedback#new'
      post '/feedback' => 'feedback#create'

      get '/stats' => 'stats#index'
    end

    get '/apply' => 'claims#new'
    get '/apply/refund' => 'refunds#new'
    root to: redirect('/apply')
    get '/:locale/apply/admin', to: redirect('/apply/admin')
    get '/:locale/apply/sidekiq', to: redirect('/apply/sidekiq')

  end

  scope :apply do
    ActiveAdmin.routes(self) unless $ARGV.include?('db:create')
    mount Sidekiq::Web => '/sidekiq'
  end

  if Rails.env.test?
    match '/test/valid_pdf', to: -> (_env) { [200, {'Content-Type' => 'application/pdf'}, ['anything']] }, as: :test_valid_pdf, via: :all
    match '/test/invalid_pdf', to: -> (_env) { [404, {'Content-Type' => 'application/pdf'}, ['Not Found']] }, as: :test_invalid_pdf, via: :all
  end

end
