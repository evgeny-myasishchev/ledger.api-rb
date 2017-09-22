# frozen_string_literal: true

Rails.application.routes.draw do
  get '/' => 'health#index'

  namespace :v1 do
    resources :accounts, only: %i[index create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
