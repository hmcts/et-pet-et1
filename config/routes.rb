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

    get 'ping' => 'ping#index'

    resource :user_session, only: %i<create destroy new>, path: :session do
      member do
        get :touch
        get :expired
      end
    end
  end

  get '/apply' => 'claims#new'
  root to: redirect('/apply')
end
