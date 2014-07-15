Rails.application.routes.draw do
  get 'static/review'

  resource :claim, only: %i<create update>, path: 'apply' do
    member do
      get ':page', to: 'claims#show', as: :page
    end
  end

  root to: 'claims#new'
end
