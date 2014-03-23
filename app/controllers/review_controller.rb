
class ReviewController < ApplicationController
  include ReviewConcern

  def index
    redirect_to next_review_url
  end

end