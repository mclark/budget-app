require 'transferize_policy'

class TransactionsController < ApplicationController

  def index
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.update(filtered_params)
      redirect_to params[:return_to].presence || transactions_path, notice: "Transaction updated"
    else
      render action: 'edit'
    end
  end

  def transferize
    from = Transaction.find(params[:from_id])
    to = Transaction.find(params[:to_id])

    if (reason = TransferizePolicy.new(from, to).validate) == true
      TransferizeService.new(from, to).call
      render json: {}, status: :ok
    else
      render json: {reason: reason}, status: :bad_request
    end
  end

private

  def filtered_params
    params.require(:transaction).permit(:category_id, :notes)
  end

  def scope
    _scope = Transaction.order("date desc, cents desc, type desc, id asc").includes(:account, :category)
    _scope = _scope.where(account_id: params[:account_id]) if params[:account_id]
    _scope = _scope.where(category_id: params[:category_id]) if params[:category_id]
    _scope
  end

  def query
    @query ||= scope.ransack(params[:q])
  end
  helper_method :query

  def collection
    query.result.page(params.fetch(:page, 1)).per(50)
  end
  helper_method :collection

end