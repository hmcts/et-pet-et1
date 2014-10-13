Rails.application.routes.draw do
  resource :guide, only: :show

  resource :claim_review, only: %i<show update>, path: 'apply/review'

  resource :claim_confirmation, only: :show, path: 'apply/confirmation' do
    get 'generated_claim', on: :member
  end

  resource :claim_review, only: %i<show update>, path: 'apply/review'
  resource :user_session

  resource :claim, only: %i<create update>, path: 'apply' do
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

  root to: 'claims#new'

  get 'ping' => 'ping#index'
end
