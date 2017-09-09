# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    resources :accounts, only: :index
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
