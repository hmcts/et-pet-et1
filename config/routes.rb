Rails.application.routes.draw do

  resource :guide, only: :show

  resource :user_session, only: %i<create update>, path: :application do
    member do
      get 'reminder'
      get 'returning'
    end
  end

  scope :apply do
    resource :claim_review, only: %i<show update>, path: :review

    resource :claim_confirmation, only: :show, path: :confirmation do
      get 'generated_claim', on: :member
    end

    resource :claim, only: %i<create update>, path: "/" do
      resource :payment, only: %i<show update>, path: :pay do
        member do
          %i<success decline>.each do |result|
            get result, to: "payments##{result}", as: result
          end
        end
      end

      member do
        get ':page', to: 'claims#show', as: :page
      end
    end
  end

  root to: 'claims#new'

  get 'ping' => 'ping#index'
end
