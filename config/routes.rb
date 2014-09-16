Rails.application.routes.draw do
  get 'ping' => 'ping#index'

  resource :claim, only: %i<create update>, path: 'apply' do
    resource :claim_review, only: %i<show update>, path: 'review'

    resource :payment, only: %i<show update>, path: 'pay' do
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

  resource :user_sessions, only: %i<new create show destroy>

  root to: 'claims#new'
end
