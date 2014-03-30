MintApp::Application.routes.draw do
  root to: 'dashboard#show'

  get 'review', to: "review#index"
  scope path: 'review' do
    resources :accounts, controller: "mint_accounts", as: "mint_account", only: %i(show update)
    resources :transactions, controller: "mint_transactions", as: "mint_transaction", only: %i(show update)
  end

  resources :transactions, only: %i(index edit update) do
  end

  patch "/transactions/:from_id/transferize/:to_id", as: :transferize_transaction, to: "transactions#transferize"

  resources :accounts do
    resources :transactions, only: %i(index)
  end

  resources :categories do
    resources :transactions, only: %i(index)
  end

  scope path: 'reports' do
    get 'monthly-cashflow', to: "reports/monthly_cashflow#show", as: :current_monthly_cashflow_report
    get 'monthly-cashflow/:year-:month', to: 'reports/monthly_cashflow#show', as: :monthly_cashflow_report, year: /\d{4}/, month: /\d{1,2}/
  end
end
