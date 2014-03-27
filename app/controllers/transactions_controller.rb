
class TransactionsController < ApplicationController

  def index
  end

private

  def scope
    _scope = Transaction.order("date desc").includes(:account, :category)
    _scope = _scope.where(account_id: params[:account_id]) if params[:account_id]
    _scope = _scope.where(category_id: params[:category_id]) if params[:category_id]
    _scope
  end

  def collection
    scope.page(params.fetch(:page, 1)).per(50)
  end
  helper_method :collection

end