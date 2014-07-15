Rails.application.routes.draw do

  resource :claim, only: %i<create update>, path: 'apply' do
    member do
      get ':page', to: 'claims#show', as: :page
    end
  end

  root to: 'claims#new'

  get ':controller/:action'
end
