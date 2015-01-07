
module Reports
  class CategorySpendingController < ApplicationController

    def index
      @income_categories = Category.income.descendants.order(:name)
      @expense_categories = Category.expense.descendants.order(:name)
    end

    def show
      @category = Category.find(params[:category_id])
      @report = CategoricalSpendingReport.new(@category)
    end

  end
end