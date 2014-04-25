Budget::Application.routes.draw do
  root to: 'reports/monthly_budget#show'

  get 'review', to: "review#index"
  scope path: 'review' do
    resources :accounts, controller: "mint_accounts", as: "mint_account", only: %i(show update)
    resources :transactions, controller: "mint_transactions", as: "mint_transaction", only: %i(show update)
  end

  resources :transactions, only: %i(index edit update) do
  end

  patch "/transactions/:from_id/transferize/:to_id", as: :transferize_transaction, to: "transactions#transferize"

  resources :accounts
  resources :categories

  scope path: 'reports' do
    scope to: "reports/monthly_cashflow#show" do
      get 'monthly-cashflow', as: :current_monthly_cashflow_report
      get 'monthly-cashflow/:year-:month', as: :monthly_cashflow_report, year: /\d{4}/, month: /\d{1,2}/
    end

    scope to: "reports/monthly_budget#show" do
      get 'monthly-budget', as: :current_monthly_budget_report
      get 'monthly-budget/:year-:month', as: :monthly_budget_report, year: /\d{4}/, month: /\d{1,2}/
    end
  end
end
