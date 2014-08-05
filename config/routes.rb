Rails.application.routes.draw do
  mount Peek::Railtie => '/peek'

  resource :claim, only: %i<create update>, path: 'apply' do
    resource :claim_review, only: %i<show update>, path: 'review' 
    member do
      get ':page', to: 'claims#show', as: :page
    end
  end

  root to: 'claims#new'
end
