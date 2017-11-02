# frozen_string_literal: true

Rails.application.routes.draw do
  get '/' => 'health#index'

  namespace :v1 do
    resources :ledgers, only: %i[index create] do
      resources :accounts, only: %i[index create], shallow: true
      resources :'account-categories', only: %i[index create], controller: 'account_categories', as: 'account_categories', shallow: true
      resources :tags, only: %i[index create], shallow: true
    end
    resources :accounts, only: %i[] do
      resources :transactions, only: %i[index create]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
