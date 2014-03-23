MintApp::Application.routes.draw do
  root to: 'dashboard#show'

  get 'review', to: "review#index"
  scope path: 'review' do
    resources :accounts, controller: "mint_accounts", as: "mint_account", only: %i(show update)
    resources :transactions, controller: "mint_transactions", as: "mint_transaction", only: %i(show update)
  end

  resources :transactions, only: %i(index)

  resources :accounts do
    resources :transactions, only: %i(index)
  end

  resources :categories do
    resources :transactions, only: %i(index)
  end
end
