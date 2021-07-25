Rails.application.routes.draw do
  resources :inquiries, only: %i(new)
  resources :aws_ses, only: %i(create)
end
